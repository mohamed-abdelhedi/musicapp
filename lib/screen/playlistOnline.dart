import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/screen/songoverview.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class playlistonlinetWidget extends StatefulWidget {
  const playlistonlinetWidget({Key? key, required this.playlistID})
      : super(key: key);
  final String playlistID;
  @override
  _playlistonlinetWidgetState createState() => _playlistonlinetWidgetState();
}

class _playlistonlinetWidgetState extends State<playlistonlinetWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late String playlistID = widget.playlistID;

  bool _isPlayerContorlsWidgetVisible = false;
  @override
  void initState() {
    super.initState();
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
  Future<List<Video>> Getplaylist() async {
    var videos = await yt.playlists.getVideos(playlistID);

    return videos.toList();
  }

  Future<List<Map>> convertvideotoaudio() async {
    List<Video> videos = await Getplaylist();
    List<Map> allsongs = [];
    for (int i = 0; i < videos.length; i++) {
      var video =
          await yt.videos.get('https://youtube.com/watch?v=${videos[i].id}');
      final manifest = await yt.videos.streamsClient.getManifest(videos[i].id);
      String songurl = manifest.muxed.last.url.toString();
      String imgurl =
          'https://img.youtube.com/vi/${videos[i].id}/hqdefault.jpg';

      allsongs.addAll([
        {
          'id': videos[i].id,
          'title': video.title,
          'duration': video.duration,
          'url': songurl,
          'imgurl': imgurl,
        }
      ]);
    }

    return allsongs;
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

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget songsListView() {
    return FutureBuilder(
      future: Getplaylist(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var songs = snapshot.data!;
        print(songs);
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  // await _audioPlayer.setAudioSource(AudioSource.uri(
                  //   Uri.parse(item.data![index].uri!),
                  //   tag: MediaItem(
                  //     // Specify a unique ID for each media item:
                  //     id: '1',
                  //     // Metadata to display in the notification:
                  //     album: songs.title  ?? 'unknown',
                  //     title: item.data![index].title,
                  //     artUri: Uri.parse('https://picsum.photos/seed/204/600'),
                  //   ),
                  // ));

                  //playsong(item.data![index].uri);
                  // ignore: use_build_context_synchronously
                  _audioPlayer.play();
                  // ignore: use_build_context_synchronously
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SongoverviewWidget(
                  //               playlist: returnplaylist(songs),
                  //               index: index,
                  //               player: _audioPlayer,
                  //             )));
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          songs[index].title,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: const AlignmentDirectional(0.9, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                songs[index].duration.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
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
                                        child: Text(
                                          'Favorite Tracks',
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
                                        '11 songs',
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
                                          const AlignmentDirectional(0.65, 0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 0,
                                        buttonSize: 70,
                                        icon: const Icon(
                                          Icons.play_circle_fill,
                                          color: Color(0xFF0685CE),
                                          size: 60,
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
        bottomNavigationBar: const bottomappbarCustom());
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
