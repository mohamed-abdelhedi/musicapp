import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

class SongoverviewWidget extends StatefulWidget {
  const SongoverviewWidget({Key? key}) : super(key: key);

  @override
  _SongoverviewWidgetState createState() => _SongoverviewWidgetState();
}

class _SongoverviewWidgetState extends State<SongoverviewWidget> {
  late AudioPlayer _audioPlayer = AudioPlayer();

  double? sliderValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: "Album name",
        title: "Song name",
        artUri: Uri.parse('https://picsum.photos/seed/204/600'),
      ),
    ),
    AudioSource.uri(
      Uri.parse(' '),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: "Album name",
        title: "Song name",
        artUri: Uri.parse('https://picsum.photos/seed/205/600'),
      ),
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
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
      backgroundColor: Color(0xFF23262A),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                        print('IconButton pressed ...');
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
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
                      alignment: AlignmentDirectional(0, 0),
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
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                        child: Image.network(
                          'https://picsum.photos/seed/488/600',
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 60, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Baby boy',
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
                                    'Childish Gambio',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF565A5E),
                                        ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(0.75, 0),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30,
                                    borderWidth: 1,
                                    buttonSize: 60,
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 30, 20, 0),
                        child: StreamBuilder(
                            stream: _PositionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return ProgressBar(
                                barHeight: 4,
                                baseBarColor: Colors.grey,
                                bufferedBarColor: Colors.grey,
                                progressBarColor: Color(0xFF0685CE),
                                thumbColor: Color(0xFF0685CE),
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
      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.shuffle,
              color: Color(0xFF4E5D75),
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: FaIcon(
              FontAwesomeIcons.angleDoubleLeft,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              audioPlayer.seekToPrevious;
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
                    icon: Icon(
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
                    icon: Icon(
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
            icon: FaIcon(
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
            icon: Icon(
              Icons.repeat,
              color: Color(0xFF4E5D75),
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
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
    return Column(
      children: [],
    );
  }
}
