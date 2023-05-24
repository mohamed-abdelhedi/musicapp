import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';

import 'package:musicapp/screen/bottomappbar2.dart';
import 'package:musicapp/screen/homepage.dart';
import 'package:musicapp/screen/songoverview/songoverview.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class localplaylisttWidget extends StatefulWidget {
  const localplaylisttWidget({Key? key}) : super(key: key);

  @override
  _localplaylisttWidgetState createState() => _localplaylisttWidgetState();
}

class _localplaylisttWidgetState extends State<localplaylisttWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Directory? dir;
  File file = File('');
  Directory directory = new Directory('');

  String path = '';
  List<SongModel> allSongs = <SongModel>[];
  bool _isPlayerContorlsWidgetVisible = false;
  @override
  void initState() {
    super.initState();
    requestPermission();
    initAsyncState();
    getsong();
  }

  Future<void> getsong() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var path = preferences.getString('path');

    file = File(path!);

    try {
      if (file.existsSync()) {
        file.deleteSync();
        _audioQuery.scanMedia(file.path); // Scan the media 'path'
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {}
  }

  List<AudioSource> playlist = [];
  List<AudioSource> returnplaylist(_songModelList) {
    for (int i = 0; i < _songModelList.length; i++) {
      playlist.add(AudioSource.uri(
        Uri.parse(_songModelList[i].uri!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: i.toString(),
          // Metadata to display in the notification:
          artist: _songModelList[i].artist,
          title: _songModelList[i].displayName,
          artUri: Uri.parse('assets/images/musicartwork.png'),
        ),
      ));
    }
    final _playlist = ConcatenatingAudioSource(children: playlist);

    return playlist;
  }

  List<String> paths = [];
  Future<void> initAsyncState() async {
    // Your async code here
    var permisson = Permission.storage.request();
    var status = Permission.storage.status;
    final dir = await getExternalStorageDirectory();
    final path = dir?.path;

    final directory = Directory('$path');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('path', path!);
    final List<FileSystemEntity> entities = await directory.list().toList();
    List<String> paths = [];
    entities.forEach((file) {
      if (file.path.endsWith('.mp3')) {
        paths.add(file.path);
      }
    });
    setState(() {
      this.path = path;
      this.paths = paths;
      this.dir = dir;
    });
  }

  requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  // Future<void> getAllSongs() async {
  //   songs = await audioQuery.getSongs();
  //   setState(() {});
  // }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  void changePlayerControlsWidgetVisibility() {
    setState(() {
      _isPlayerContorlsWidgetVisible = !_isPlayerContorlsWidgetVisible;
    });
  }

  Widget songsListView() {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(),
      builder: (context, item) {
        if (item.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (item.data!.isEmpty) {
          return const Center(
              child: Text(
            "No songs Found!! , Download Some",
            style: TextStyle(
              color: Colors.white,
            ),
          ));
        }
        List<SongModel> songs = item.data!;

        return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              allSongs.addAll(songs);
              return InkWell(
                onTap: () async {
                  _audioPlayer.stop();
                  await _audioPlayer.setAudioSource(AudioSource.uri(
                    Uri.parse(songs[index].uri!),
                    tag: MediaItem(
                      id: '1',
                      album: songs[index].artist ?? 'unknown',
                      title: songs[index].title,
                      artUri: Uri.parse('https://picsum.photos/seed/204/600'),
                    ),
                  ));

                  //playsong(songs[index].uri);
                  // ignore: use_build_context_synchronously
                  _audioPlayer.play();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SongoverviewWidget(
                                playlist: returnplaylist(songs),
                                index: index,
                                player: _audioPlayer,
                              )));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                      child: Icon(
                        Icons.music_note_sharp,
                        size: MediaQuery.of(context).size.width * 0.07,
                        color: const Color(0xFF0685CE),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.05,
                        child: Marquee(
                          text:
                              '${item.data!.elementAt(index).displayName}                                                ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          pauseAfterRound: const Duration(seconds: 7),
                          startPadding: 10.0,
                          accelerationDuration: const Duration(seconds: 3),
                          accelerationCurve: Curves.linear,
                          decelerationDuration:
                              const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        )),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0.9, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30,
                              borderWidth: 1,
                              buttonSize: 60,
                              icon: Icon(
                                Icons.drag_handle,
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                size: 30,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF25282C),
        body: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.91,
                      decoration: const BoxDecoration(
                        color: Color(0xFF25282C),
                      ),
                      alignment: const AlignmentDirectional(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, -0.75),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: const BoxDecoration(
                                color: Color(0xFF244975),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 15,
                                    borderWidth: 1,
                                    buttonSize: 60,
                                    icon: FaIcon(
                                      FontAwesomeIcons.angleLeft,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePageWidget()),
                                      );
                                    },
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 40, 0, 0),
                                        child: Text(
                                          'Local Tracks',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBtnText,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        'downloaded songs',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: const Color(0xFF557294),
                                              fontSize: 15,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 30, 0, 0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF23262A),
                                  ),
                                  child: Container(
                                    child: songsListView(),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const bottomappbarCustom2());
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });
  final String imageUrl;
  final String title;
  final String artist;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 4),
                        blurRadius: 4,
                      )
                    ], borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: "https://picsum.photos/seed/205/600",
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'title',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  'artist',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: const Color(0xFF565A5E),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        )))
              ]))
    ]);
  }
}
