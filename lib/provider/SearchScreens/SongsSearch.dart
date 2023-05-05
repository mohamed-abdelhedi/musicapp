import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:musicapp/flutter_flow/flutter_flow_icon_button.dart';
import 'package:musicapp/flutter_flow/flutter_flow_theme.dart';
import 'package:musicapp/screen/songoverview/songoverviewonline.dart';
import 'package:musicapp/services/youtube_services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musicapp/provider/SearchProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:isolate';
// import 'package:musicapp/widgets/TrackTile.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch({this.query = "", super.key});

  final String query;
  @override
  State<SongsSearch> createState() => _SongsSearchState();
}

final OnAudioQuery _audioQuery = OnAudioQuery();
final AudioPlayer _audioPlayer = AudioPlayer();
bool fetched = false;
List<Map> searchedList = [];
bool done = true;
var yt = YoutubeExplode();

class _SongsSearchState extends State<SongsSearch> {
  @override
  ReceivePort _port = ReceivePort();
  void initState() {
    super.initState();
    var permisson = Permission.storage.request();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    //FlutterDownloader.registerCallback((id, status, progress) { })
  }

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  var yt = YoutubeExplode();
  // Future<String> getMusicVideo(songId) async {
  //   final manifest = await yt.videos.streamsClient.getManifest(songId);
  //   return manifest.muxed.last.url.toString();
  // }

  // String uri(songId) {
  //   return getMusicVideo(songId).toString();
  // }

  // Future<void> downloadVideo(id) async {
  //   var permisson = await Permission.storage.request();
  //   if (permisson.isGranted) {
  //     var _youtubeExplode = YoutubeExplode();

  //     //get video metadata
  //     var video = await _youtubeExplode.videos.get(id);
  //     // var manifest = await _youtubeExplode.videos.streamsClient.getManifest(id);
  //     // var streams = manifest..audioOnly.withHighestBitrate();
  //     // var audio = streams;

  //     //create a directory
  //     final basestorage = await getExternalStorageDirectory();
  //     final id = await FlutterDownloader.enqueue(
  //         url: 'url', savedDir: basestorage!.path, fileName: 'filename');
  //     var file = File('$appDocPath/${video.id}');
  //     //delete file if exists
  //     if (file.existsSync()) {
  //       file.deleteSync();
  //     }
  //   } else {
  //     await Permission.storage.request();
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Logger.root.info('calling youtube search');
    EasyThrottle.throttle(
        'my-debouncer', // <-- An ID for this particular debouncer
        Duration(milliseconds: 2000), // <-- The debounce duration
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
                    final itemType =
                        section['items'][idx]['type']?.toString() ?? 'Video';

                    return GestureDetector(
                      onLongPress: () {},
                      child: ListTile(
                        trailing: PopupMenuButton(
                          color: Color(0xFF244975),
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'Download',
                                child: Text(
                                  'Donwload',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () async {
                                  //  downloadVideo(section['items'][idx]['id']);
                                  // log(section['items'][idx].toString());
                                  var permisson =
                                      await Permission.storage.request();
                                  if (permisson.isGranted) {
                                    var manifest = await yt.videos.streamsClient
                                        .getManifest(
                                            section['items'][idx]['id']);

                                    //   var streamInfo =
                                    //       manifest.audioOnly.withHighestBitrate();
                                    var streamInfo =
                                        manifest.audioOnly.withHighestBitrate();
                                    log(streamInfo.toString());
                                    if (streamInfo != null) {
                                      // Get the actual stream
                                      var stream = yt.videos.streamsClient
                                          .get(streamInfo);

                                      // Open a file for writing.
                                      var appDir =
                                          await getApplicationDocumentsDirectory();
                                      var filePath =
                                          '${appDir.path}/${section['items'][idx]['id']}.mp3';
                                      var appDirPath = appDir.path;
                                      // var filePath = join(appDirPath, '<file name>');
                                      var file = File(filePath);
                                      var dio = Dio();
                                      var response = await dio.get(
                                        streamInfo.url.toString(),
                                        options: Options(
                                            responseType: ResponseType.stream),
                                      );

                                      // Save the stream to the file
                                      //  var stream = response.data;
                                      await stream.pipe(file.openWrite());

                                      // Pipe all the content of the stream into the file.
                                      //  await stream.pipe(fileStream);

                                      //   // Close the file.
                                      ////  await fileStream.flush();
                                      // await fileStream.close();
                                    }
                                  }

                                  // log(streamInfo.toString());

                                  // if (permisson.isGranted) {
                                  //   var _youtubeExplode = YoutubeExplode();

                                  //   //get video metadata
                                  //   String songid = section['items'][idx]['id'];
                                  //   final manifest = await yt
                                  //       .videos.streamsClient
                                  //       .getManifest(songid);
                                  //   String songurl =
                                  //       manifest.muxed.last.url.toString();
                                  //   log(songurl.toString());
                                  //
                                  //   final taskId =
                                  //       await FlutterDownloader.enqueue(
                                  //     url: songurl,
                                  //     headers: {}, // optional: header send with url (auth token etc)
                                  //     savedDir: basestorage!.path,
                                  //     fileName: section['items'][idx]['name'],
                                  //     showNotification:
                                  //         true, // show download progress in status bar (for Android)
                                  //     openFileFromNotification:
                                  //         true, // click on notification to open downloaded file (for Android)
                                  //   );
                                  // }
                                },
                              ),
                              PopupMenuItem(
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
                        subtitle: Text(
                          section['items'][idx]['subtitle'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF40444A),
                          ),
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
                                return Icon(Icons.error);
                              }
                            },
                            imageUrl: section['items'][idx]['secondImage'],
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
                              artUri: Uri.parse(section['items'][idx]
                                      ['image'] ??
                                  section['items'][idx]['secondImage']),
                            ),
                          ));
                          _audioPlayer.play();

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SongoverviewWidgetonline(
                                        playlist: [section['items'][idx]],
                                        index: idx,
                                        player: _audioPlayer,
                                      )));
                        },
                      ),
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
