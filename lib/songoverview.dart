import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

class SongoverviewWidget extends StatefulWidget {
  const SongoverviewWidget(
      {Key? key,
      required this.songModelList,
      required this.index,
      required this.player})
      : super(key: key);
  final List<SongModel> songModelList;
  final int index;
  final AudioPlayer player;

  @override
  _SongoverviewWidgetState createState() => _SongoverviewWidgetState();
}

class _SongoverviewWidgetState extends State<SongoverviewWidget> {
  late AudioPlayer _audioPlayer = AudioPlayer();
  late AudioPlayer _audioPlayerall = AudioPlayer();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  double? sliderValue;
  bool _isPlaying = false;
  List<AudioSource> songList = [];

  int currentIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.player.seek(duration);
  }

  // void parseSong() {
  //   try {
  //     for (var element in widget.songModelList) {
  //       songList.add(
  //         AudioSource.uri(
  //           Uri.parse(element.uri!),
  //           tag: MediaItem(
  //             id: element.id.toString(),
  //             album: element.album ?? "No Album",
  //             title: element.displayNameWOExt,
  //             artUri: Uri.parse(element.id.toString()),
  //           ),
  //         ),
  //       );
  //     }

  //     widget.player.setAudioSource(
  //       ConcatenatingAudioSource(children: songList),
  //     );
  //     widget.player.play();
  //     _isPlaying = true;

  //     widget.player.durationStream.listen((duration) {
  //       if (duration != null) {
  //         setState(() {
  //           _duration = duration;
  //         });
  //       }
  //     });
  //     widget.player.positionStream.listen((position) {
  //       setState(() {
  //         _position = position;
  //       });
  //     });
  //     listenToEvent();
  //     listenToSongIndex();
  //   } on Exception catch (_) {
  //     popBack();
  //   }
  // }

  // void listenToEvent() {
  //   widget.player.playerStateStream.listen((state) {
  //     if (state.playing) {
  //       setState(() {
  //         _isPlaying = true;
  //       });
  //     } else {
  //       setState(() {
  //         _isPlaying = false;
  //       });
  //     }
  //     if (state.processingState == ProcessingState.completed) {
  //       setState(() {
  //         _isPlaying = false;
  //       });
  //     }
  //   });
  // }

  // void listenToSongIndex() {
  //   widget.player.currentIndexStream.listen(
  //     (event) {
  //       setState(
  //         () {
  //           if (event != null) {
  //             currentIndex = event;
  //           }
  //           context
  //               .read<SongModelProvider>()
  //               .setId(widget.songModelList[currentIndex].id);
  //         },
  //       );
  //     },
  //   );
  // }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  // final _playlist = ConcatenatingAudioSource(children: [
  //   AudioSource.uri(
  //     Uri.parse(
  //         'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
  //     tag: MediaItem(
  //       // Specify a unique ID for each media item:
  //       id: '1',
  //       // Metadata to display in the notification:
  //       artist: "Album name",
  //       title: "Song name",
  //       artUri: Uri.parse('https://picsum.photos/seed/204/600'),
  //     ),
  //   ),
  //   AudioSource.uri(
  //     Uri.parse(' '),
  //     tag: MediaItem(
  //       // Specify a unique ID for each media item:
  //       id: '1',
  //       // Metadata to display in the notification:
  //       artist: "Album name",
  //       title: "Song name",
  //       artUri: Uri.parse('https://picsum.photos/seed/205/600'),
  //     ),
  //   ),
  // ]);

  late List<SongModel> _songModelList = [];
  late int index;

  // void loadSongs() {
  //   // Load songs from a data source
  //   _songModelList =
  //       widget.songModelList; // Assign the loaded songs to _songModelList
  // }

  // playsong(String uri) {
  //   try {
  //     _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
  //   } on Exception {
  //     log("error parsing song");
  //   }
  // }
  List<AudioSource> playlist = [];
  // @override
  void initState() {
    super.initState();

    index = widget.index;
    _songModelList = widget.songModelList;
    _audioPlayer = widget.player;
    _audioPlayerall = widget.player;

    _init();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _init() async {
    String uri = _songModelList[index].uri!;
    String album = _songModelList[index].artist ?? '';
    String artUri = _songModelList[index].displayName;
    print('--------------');
    log(_songModelList[index].toString());
    print('--------------');

    await _audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(uri),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: album,
        title: artUri,
        artUri: Uri.parse('https://picsum.photos/seed/204/600'),
      ),
    ));

    for (int i = 0; i < _songModelList.length; i++) {
      playlist.add(AudioSource.uri(
        Uri.parse(_songModelList[i].uri!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: i.toString(),
          // Metadata to display in the notification:
          artist: _songModelList[i].artist,
          title: _songModelList[i].displayName,
          artUri: Uri.parse('https://picsum.photos/seed/204/600'),
        ),
      ));
    }
    log(playlist.toString());
    final _playlist = ConcatenatingAudioSource(children: playlist);

    await _audioPlayerall.setLoopMode(LoopMode.all);
    await _audioPlayerall.setAudioSource(_playlist);
  }

  void playprevious() {
    if (index - 1 < 0) {
      _audioPlayer.setAudioSource(playlist[index - 1]);
      index = index - 1;
      _audioPlayer.play();
    }
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
      body: SafeArea(
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
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
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
                              imageUrl: 'https://picsum.photos/seed/205/600',
                              artist: metadata.artist ?? '',
                              title: metadata.title,
                            );
                          }),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 0),
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
                                total: positionData?.duration ?? Duration.zero,
                                onSeek: _audioPlayer.seek,
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Controls(
                        audioPlayer: _audioPlayer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
  });
  final AudioPlayer audioPlayer;

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
              audioPlayer.seekToPrevious();
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
                                  title,
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
