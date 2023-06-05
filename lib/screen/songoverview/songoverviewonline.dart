import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:musicapp/provider/song_model_provider.dart';
import 'package:musicapp/services/download.dart';
import 'package:musicapp/services/model/genreclassificationapi.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
import 'package:http/http.dart' as http;

class SongoverviewWidgetonline extends StatefulWidget {
  const SongoverviewWidgetonline(
      {Key? key,
      required this.playlist,
      required this.index,
      required this.player})
      : super(key: key);
  final List<dynamic> playlist;
  final int index;
  final AudioPlayer player;

  @override
  _SongoverviewWidgetonlineState createState() =>
      _SongoverviewWidgetonlineState();
}

class _SongoverviewWidgetonlineState extends State<SongoverviewWidgetonline> {
  late AudioPlayer _audioPlayer = AudioPlayer();
  late AudioPlayer _audioPlayerall = AudioPlayer();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  double? sliderValue;
  bool _isPlaying = false;
  List<AudioSource> songList = [];
  Directory? dir;
  File file = File('');
  Directory directory = new Directory('');

  String? path;
  int currentIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  Future<void> initAsyncState() async {
    var permisson = Permission.storage.request();
    var status = Permission.storage.status;
    final dir = await getExternalStorageDirectory();
    final path = dir?.path;
    final path2 =
        path?.replaceAll('Android/data/com.example.musicapp/files', 'Download');
    log(path2.toString());
    final directory = Directory('$path');
    setState(() {
      this.path = path2;
      this.dir = dir;
    });
  }

  Future<String> classify(String filepath, String name) async {
    // Replace <URL> with the actual URL where you want to send the request
    var url = Uri.parse('http://192.168.1.17:5000/upload');

    // Replace <PATH_TO_AUDIO_FILE> with the path to your audio file in the emulator
    var file = File(filepath);

    // Read the file as bytes
    var bytes = await file.readAsBytes();

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);
    Fluttertoast.showToast(
      msg: 'classify model begin',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );

    request.files.add(
      http.MultipartFile.fromBytes('audio', bytes, filename: name),
    );
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    return responseString;
  }

  var yt = YoutubeExplode();

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.player.seek(duration);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  late int index;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  List<dynamic> playlist = [];
  // @override
  void initState() {
    super.initState();
    initAsyncState();
    index = widget.index;
    playlist = widget.playlist;
    _audioPlayer = widget.player;
    _audioPlayerall = widget.player;
    log(playlist.toString());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Stream<PositionData> get _PositionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF23262A),
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 60,
                        icon: FaIcon(
                          FontAwesomeIcons.angleLeft,
                          color: FlutterFlowTheme.of(context).primaryBtnText,
                          size: 30,
                        ),
                        onPressed: () {
                          popBack();
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            'PLAYING NOW',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30,
                              borderWidth: 1,
                              buttonSize: 60,
                              icon: Icon(
                                Icons.playlist_play,
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                                size: 30,
                              ),
                              onPressed: () {
                                popBack();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<SequenceState?>(
                            stream: _audioPlayer.sequenceStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data;
                              if (state?.sequence.isEmpty ?? true) {
                                return const SizedBox();
                              }
                              final metadata =
                                  state!.currentSource!.tag as MediaItem;

                              return MediaMetadata(
                                imageUrl: 'https://picsum.photos/200',
                                //playlist[0]['secondImage'],
                                artist: metadata.artist ?? '',
                                title: metadata.title,
                              );
                            }),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              30, 30, 30, 0),
                          child: StreamBuilder(
                              stream: _PositionDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;
                                return ProgressBar(
                                  barHeight: 4,
                                  baseBarColor: Colors.grey,
                                  bufferedBarColor: Colors.grey,
                                  progressBarColor: const Color(0xFF0685CE),
                                  thumbColor: const Color(0xFF0685CE),
                                  timeLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  progress:
                                      positionData?.position ?? Duration.zero,
                                  buffered: positionData?.bufferedPosition ??
                                      Duration.zero,
                                  total:
                                      positionData?.duration ?? Duration.zero,
                                  onSeek: _audioPlayer.seek,
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: const Icon(
                                  Icons.shuffle,
                                  color: Color(0xFF4E5D75),
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: const FaIcon(
                                  FontAwesomeIcons.angleDoubleLeft,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // playprevious();
                                  // if (index - 1 >= -1) {
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               SongoverviewWidgetonline(
                                  //                 playlist: playlist,
                                  //                 index: index - 1,
                                  //                 player: _audioPlayer,
                                  //               )));
                                  // }
                                },
                              ),
                              StreamBuilder<PlayerState>(
                                  stream: _audioPlayer.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    final processingState =
                                        playerState?.processingState;
                                    final playing = playerState?.playing;
                                    if (!(playing ?? false)) {
                                      return FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30,
                                        borderWidth: 1,
                                        buttonSize: 80,
                                        icon: const Icon(
                                          Icons.play_circle_fill_outlined,
                                          color: Color(0xFF0685CE),
                                          size: 60,
                                        ),
                                        onPressed: _audioPlayer.play,
                                      );
                                    } else if (processingState !=
                                        ProcessingState.completed) {
                                      return FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30,
                                        borderWidth: 1,
                                        buttonSize: 80,
                                        icon: const Icon(
                                          Icons.pause_circle_filled_outlined,
                                          color: Color(0xFF0685CE),
                                          size: 60,
                                        ),
                                        onPressed: _audioPlayer.pause,
                                      );
                                    }
                                    return const Icon(
                                      Icons.play_circle_fill_outlined,
                                      color: Color(0xFF0685CE),
                                      size: 60,
                                    );
                                  }),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: const FaIcon(
                                  FontAwesomeIcons.angleDoubleRight,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // playnext();
                                  // if (index + 1 <= playlist.length + 1) {
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               SongoverviewWidgetonline(
                                  //                 playlist: playlist,
                                  //                 index: index + 1,
                                  //                 player: _audioPlayer,
                                  //               )));
                                  // }
                                },
                              ),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: const Icon(
                                  Icons.download_outlined,
                                  color: Color(0xFF4E5D75),
                                  size: 30,
                                ),
                                onPressed: () async {
                                  final fileName =
                                      '${playlist[0]['title']}.webm'
                                          .replaceAll(r'\', '')
                                          .replaceAll('/', '')
                                          .replaceAll('*', '')
                                          .replaceAll('?', '')
                                          .replaceAll('"', '')
                                          .replaceAll('<', '')
                                          .replaceAll('>', '')
                                          .replaceAll('|', '')
                                          .replaceAll(' ', '_');
                                  await downloadsong(
                                      playlist[0], path, fileName);
                                  var filePath =
                                      '$path/${fileName.replaceAll('.webm', '.mp3')}';
                                  log(filePath);

                                  String genre = await classify(filePath,
                                      fileName.replaceAll('.webm', '.mp3'));
                                  log(genre);
                                  String genref = genre.replaceAll('"', '');

                                  if (genref != null) {
                                    Map<String, dynamic> data = {
                                      'id': playlist[0]['id'],
                                      'name': playlist[0]['title'],
                                      'yt_url': playlist[0]['perma_url'],
                                      'duration': playlist[0]['duration'],
                                      'img_url': playlist[0]['secondImage']
                                    };

                                    Fluttertoast.showToast(
                                      msg: 'this song is classified as $genref',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[700],
                                      textColor: Colors.white,
                                    );
                                    CollectionReference collectionRef =
                                        FirebaseFirestore.instance
                                            .collection(genref);

                                    DocumentReference documentRef =
                                        collectionRef.doc(playlist[0]['title']);

                                    documentRef
                                        .set(data)
                                        .then((value) => print(
                                            'Document added successfully!'))
                                        .catchError((error) => print(
                                            'Failed to add document: $error'));
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.index,
  });
  final AudioPlayer audioPlayer;
  final int index;

  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.shuffle,
              color: Color(0xFF4E5D75),
              size: 30,
            ),
            onPressed: () {},
          ),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const FaIcon(
              FontAwesomeIcons.angleDoubleLeft,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              //playprevious();
            },
          ),
          StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  return FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 80,
                    icon: const Icon(
                      Icons.play_circle_fill_outlined,
                      color: Color(0xFF0685CE),
                      size: 60,
                    ),
                    onPressed: audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 80,
                    icon: const Icon(
                      Icons.pause_circle_filled_outlined,
                      color: Color(0xFF0685CE),
                      size: 60,
                    ),
                    onPressed: audioPlayer.pause,
                  );
                }
                return const Icon(
                  Icons.play_circle_fill_outlined,
                  color: Color(0xFF0685CE),
                  size: 60,
                );
              }),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const FaIcon(
              FontAwesomeIcons.angleDoubleRight,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              audioPlayer.seekToNext;
            },
          ),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.repeat,
              color: Color(0xFF4E5D75),
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class MediaMetadata extends StatelessWidget {
  MediaMetadata({
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/200',
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    title,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Text(
                                  artist,
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
