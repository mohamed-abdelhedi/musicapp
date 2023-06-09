import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

class SongoverviewWidget extends StatefulWidget {
  const SongoverviewWidget(
      {Key? key,
      required this.playlist,
      required this.index,
      required this.player})
      : super(key: key);
  final List<AudioSource> playlist;
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

  void playprevious() {
    if (index - 1 >= 0) {
      log((index - 1).toString());
      _audioPlayer.stop();
      _audioPlayer.setAudioSource(playlist[index - 1]);
      _audioPlayer.play();
    }
  }

  void playnext() {
    if (index + 1 <= playlist.length) {
      log((index + 1).toString());
      _audioPlayer.stop();
      _audioPlayer.setAudioSource(playlist[index + 1]);
      _audioPlayer.play();
    }
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.player.seek(duration);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  
  late int index;

  
  List<AudioSource> playlist = [];
  // @override
  void initState() {
    super.initState();

    index = widget.index;
    playlist = widget.playlist;
    _audioPlayer = widget.player;
    _audioPlayerall = widget.player;

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
                              imageUrl: 'assets/images/musicartwork.png',
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
                                playprevious();
                                if (index - 1 >= -1) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SongoverviewWidget(
                                                playlist: playlist,
                                                index: index - 1,
                                                player: _audioPlayer,
                                              )));
                                }
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
                                playnext();
                                if (index + 1 <= playlist.length + 1) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SongoverviewWidget(
                                                playlist: playlist,
                                                index: index + 1,
                                                player: _audioPlayer,
                                              )));
                                }
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
                      )
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
    required this.index,
  });
  final AudioPlayer audioPlayer;
  final int index;
  // void playprevious() {
  //   if (index - 1 < 0) {
  //     // List<AudioSource> playlist = _SongoverviewWidgetState().returnplaylist();
  //     audioPlayer.setAudioSource(playlist[index - 1]);
  //     audioPlayer.play();
  //   }
  // }

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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Image(
                    image: AssetImage("assets/images/musicartwork.png"),
                    width: MediaQuery.of(context).size.width * 0.7,
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
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    title,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          //fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    artist,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xFF565A5E),
                                        ),
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
