import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/screen/bottomappbar2.dart';
import 'package:musicapp/screen/songoverview/songoverviewonline%20for%20playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class playlistonlinetWidget extends StatefulWidget {
  const playlistonlinetWidget({
    Key? key,
    required this.id,
    this.playlist,
    this.title,
  }) : super(key: key);
  final id;
  final playlist;

  final title;
  @override
  _playlistonlinetWidgetState createState() => _playlistonlinetWidgetState();
}

class _playlistonlinetWidgetState extends State<playlistonlinetWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final playlist = widget.playlist;
  late final title = widget.title;
  late String id = widget.id.toString();
  bool playlist_added = false;
  bool _isPlayerContorlsWidgetVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Future<List<String>?> playlistlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var playlistlist = preferences.getStringList('playlist');
    return playlistlist;
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  playsong(String? uri) {
    try {
      _audioPlayer.stop();
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  var yt = YoutubeExplode();

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

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget songsListView() {
    return ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          Duration duration = playlist[index].duration;

          return InkWell(
            onTap: () async {
              var video = await yt.videos
                  .get('https://youtube.com/watch?v=${playlist[index].id}');
              final manifest =
                  await yt.videos.streamsClient.getManifest(playlist[index].id);
              String songurl = manifest.muxed.last.url.toString();
              log(songurl.toString());
              String imgurl =
                  'https://img.youtube.com/vi/${playlist[index].id}/hqdefault.jpg';
              await _audioPlayer.setAudioSource(AudioSource.uri(
                Uri.parse(songurl),
                tag: MediaItem(
                  // Specify a unique ID for each media item:
                  id: '1',
                  // Metadata to display in the notification:
                  album: 'fffff',
                  title: playlist[index].title,
                  artUri: Uri.parse(imgurl),
                ),
              ));
              _audioPlayer.play();
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SongoverviewWidgetonlinep(
                            playlist: playlist,
                            index: index,
                            player: _audioPlayer,
                          )));
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                      child: FadeInImage(
                        image: NetworkImage(
                            'https://img.youtube.com/vi/${playlist[index].id}/hqdefault.jpg'),
                        placeholder:
                            const AssetImage("assets/images/musicartwork.png"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/images/musicartwork.png",
                              fit: BoxFit.fitWidth);
                        },
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width * 0.15,
                      )
                      // CachedNetworkImage(
                      //   imageUrl:
                      //       'https://img.youtube.com/vi/${playlist[index].id}/maxresdefault.jpg' ??
                      //           'https://img.youtube.com/vi/${playlist[index].id}/hqdefault.jpg',
                      //   width: MediaQuery.of(context).size.width * 0.2,
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: Marquee(
                        text:
                            ' ${playlist[index].title}                                            ',
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
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )
                      // Text(
                      //   playlist[index].title,
                      //   style: FlutterFlowTheme.of(context).bodyText1.override(
                      //         fontFamily: 'Poppins',
                      //         color:
                      //             FlutterFlowTheme.of(context).primaryBackground,
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 8,
                      //       ),
                      // ),
                      ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(0.9, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBtnText,
                                    ),
                          ),
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
            ),
          );
        });
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
                                      print('IconButton pressed ...');
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
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.035,
                                            child: Marquee(
                                              text:
                                                  '${title}                   ',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              blankSpace: 20.0,
                                              velocity: 25.0,
                                              pauseAfterRound:
                                                  const Duration(seconds: 5),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                                  const Duration(seconds: 1),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration:
                                                  const Duration(seconds: 2),
                                              decelerationCurve: Curves.easeOut,
                                            ),
                                          )
                                          //  Text(
                                          //   title,
                                          //   style: FlutterFlowTheme.of(context)
                                          //       .bodyText1
                                          //       .override(
                                          //         fontFamily: 'Poppins',
                                          //         color:
                                          //             FlutterFlowTheme.of(context)
                                          //                 .primaryBtnText,
                                          //         fontSize: 20,
                                          //         fontWeight: FontWeight.w600,
                                          //       ),
                                          // ),
                                          ),
                                      Text(
                                        playlist.length.toString(),
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
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0.2, 0),
                                      child: IconButton(
                                        icon: Icon(
                                          playlist_added
                                              ? Icons.playlist_add_check
                                              : Icons.playlist_add,
                                          color: const Color(0xFF0685CE),
                                          size: 40,
                                        ),
                                        onPressed: () async {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          var playlistlist = preferences
                                              .getStringList('playlist');
                                          setState(() {
                                            playlist_added = !playlist_added;
                                          });
                                          if (playlistlist == null) {
                                            playlistlist = [];
                                          }
                                          if (playlistlist!.contains(id)) {
                                            playlistlist.remove(id);
                                            await preferences.setStringList(
                                                'playlist', playlistlist);
                                            log(playlistlist.toString());
                                          } else {
                                            playlistlist.add(id);
                                            await preferences.setStringList(
                                                'playlist', playlistlist);
                                            log(playlistlist.toString());
                                          }

                                          log(playlistlist.toString());
                                        },
                                      ),
                                    ),
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
                      fit: BoxFit.contain,
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
