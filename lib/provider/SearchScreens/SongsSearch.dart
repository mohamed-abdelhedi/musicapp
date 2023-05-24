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
                      leading: Icon(
                        Icons.music_note,
                        color: const Color(0xFF0685CE),
                        size: 30,
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
                      subtitle: Text(
                        section['items'][idx]['subtitle'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF40444A),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      onTap: () async {
                        //  _audioPlayer.stop();
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
