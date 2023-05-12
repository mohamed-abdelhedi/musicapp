// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:musicapp/screen/songoverview/songoverviewonline.dart';
import 'package:musicapp/services/youtube_services.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// import 'package:musicapp/widgets/TrackTile.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch({this.query = "", super.key});

  final String query;
  @override
  State<SongsSearch> createState() => _SongsSearchState();
}

class _SongsSearchState extends State<SongsSearch> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool fetched = false;
  List<Map> searchedList = [];
  bool done = true;
  var yt = YoutubeExplode();
  Directory? dir;
  File file = File('');
  Directory directory = new Directory('');
  String? path;
  @override
  void initState() {
    super.initState();
    initAsyncState();
  }

  Future<void> initAsyncState() async {
    var permisson = Permission.storage.request();
    var status = Permission.storage.status;
    final dir = await getExternalStorageDirectory();
    final path = dir?.path;

    final directory = Directory('$path');
    setState(() {
      this.path = path;
      this.dir = dir;
    });
  }
  //late FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger.root.info('calling youtube search');
    EasyThrottle.throttle(
        'my-debouncer', // <-- An ID for this particular debouncer
        const Duration(milliseconds: 2000), // <-- The debounce duration
        () {
      YouTubeServices().fetchSearchResults(widget.query).then((value) {
        if (mounted) {
          setState(() {
            searchedList = value;
            fetched = true;
          });
        }
      });
    });
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: searchedList.map(
          (Map section) {
            if (section['items'] == null) {
              return const SizedBox();
            }
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 20,
                    bottom: 5,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (section['items'] as List).length,
                  itemBuilder: (context, idx) {
                    final fileName = '${section['items'][idx]['title']}.webm'
                        .replaceAll(r'\', '')
                        .replaceAll('/', '')
                        .replaceAll('*', '')
                        .replaceAll('?', '')
                        .replaceAll('"', '')
                        .replaceAll('<', '')
                        .replaceAll('>', '')
                        .replaceAll('|', '');

                    final itemType =
                        section['items'][idx]['type']?.toString() ?? 'Video';
                    String path1;
                    file = File('$path/$fileName');
                    // log(file.exists().toString());

                    double progress = 0;
                    return ListTile(
                      trailing: PopupMenuButton(
                        color: const Color(0xFF244975),
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                value: 'Download',
                                child: const Text(
                                  'Download',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () async {
                                  final video = await yt.videos
                                      .get(section['items'][idx]['perma_url']);
                                  final manifest = await yt.videos.streamsClient
                                      .getManifest(
                                          section['items'][idx]['perma_url']);
                                  final streams =
                                      manifest.audioOnly.withHighestBitrate();
                                  final audio = streams;
                                  final audioStream =
                                      yt.videos.streamsClient.get(audio);

                                  await dir?.create(recursive: true);
                                  path1 = '$path/$fileName';
                                  //final file = File('$path/$fileName');
                                  if ((file.exists()) == true) {
                                    print('already downloaded');
                                  } else {
                                    final output = file.openWrite(
                                        mode: FileMode.writeOnlyAppend);
                                    var len = audio.size.totalBytes;
                                    var count = 0;
                                    var msg =
                                        'Downloading ${video.title}.${audio.container.name}';
                                    stdout.writeln(msg);
                                    await for (final data in audioStream) {
                                      count += data.length;
                                      setState(() {
                                        progress = ((count / len) * 100)
                                            .ceil()
                                            .toDouble();
                                      });
                                      print(progress);
                                      output.add(data);
                                    }
                                    await output.flush();
                                    await output.close();
                                    log(progress.toString());
                                    var filePath = '$path/$fileName';

                                    //var arguments =
                                    //     '-i $filePath -vn  -

                                    //delete webm format
                                    // if (filePath.endsWith('.webm') ||
                                    //     filePath.endsWith('.mp4')) {
                                    //   file.delete();
                                    // }
                                  }
                                }),
                            const PopupMenuItem(
                              value: 'favorite',
                              child: Text(
                                'favorite',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ];
                        },
                        onSelected: (String value) {
                          print('You Click on po up menu item');
                        },
                      ),
                      title: Text(
                        section['items'][idx]['title'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          file.exists() == true
                              ? const Icon(Icons.download_done,
                                  size: 20, color: Colors.blue)
                              : const Icon(Icons.download_for_offline,
                                  size: 20, color: Colors.blue),
                          Text(
                            section['items'][idx]['subtitle'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF40444A),
                            ),
                          ),
                          CircularProgressIndicator(
                            value: progress / 100,
                          )
                        ],
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      leading: Card(
                        margin: EdgeInsets.zero,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            itemType == 'Artist' ? 50.0 : 7.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            // If the URL is the one causing the error, return a default image widget
                            if (url ==
                                'https://img.youtube.com/vi/gCYcHz2k5x0/maxresdefault.jpg') {
                              return Image.asset(
                                  'assets/images/musicartwork.png');
                            }
                            // Otherwise, return a generic error widget
                            else {
                              return const Icon(Icons.error);
                            }
                          },
                          imageUrl: 'https://picsum.photos/seed/125/600',
                          //section['items'][idx]['secondImage'],
                          // imageUrl: section['items'][idx]['image'],
                          placeholder: (
                            context,
                            url,
                          ) =>
                              const Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/musicartwork.png',
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        _audioPlayer.stop();
                        String songid = section['items'][idx]['id'];
                        final manifest =
                            await yt.videos.streamsClient.getManifest(songid);
                        String songurl = manifest.muxed.last.url.toString();

                        await _audioPlayer.setAudioSource(AudioSource.uri(
                          Uri.parse(songurl),
                          tag: MediaItem(
                            id: section['items'][idx]['id'],
                            album: section['items'][idx]['album'],
                            title: section['items'][idx]['title'],
                            artUri: Uri.parse(section['items'][idx]['image'] ??
                                section['items'][idx]['secondImage']),
                          ),
                        ));
                        _audioPlayer.play();

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SongoverviewWidgetonline(
                                      playlist: [section['items'][idx]],
                                      index: idx,
                                      player: _audioPlayer,
                                    )));
                      },
                    );
                  },
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
