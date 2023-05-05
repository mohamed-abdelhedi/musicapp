import 'dart:developer';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/provider/song_model_provider.dart';
import 'package:musicapp/screen/songoverview/songoverview.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({Key? key}) : super(key: key);

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = <SongModel>[];

  @override
  void initState() {
    super.initState();
    requestPermission();
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

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget songsListView() {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, item) {
        if (item.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (item.data!.isEmpty) {
          return const Center(
              child: Text(
            "No songs Found!! , add Some",
            style: TextStyle(
              color: Colors.white,
            ),
          ));
        }

        return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              allSongs.addAll(item.data!);
              return GestureDetector(
                onTap: () {
                  print('-----------');
                  print(item.data!);
                  print('-----------');
                  context.read<SongModelProvider>().setId(item.data![index].id);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SongoverviewWidget(
                  //             songModelList: [item.data![index]],
                  //             player: _audioPlayer)));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                      child: Image.network(
                        'https://picsum.photos/seed/204/600',
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.07,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.data!.elementAt(index).displayName,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          "${item.data!.elementAt(index).artist}",
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF40444A),
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0.9, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.data!
                                  .elementAt(index)
                                  .duration
                                  .toString()
                                  .padLeft(2, "0"),
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
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF25282C),
        body: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.91,
                      decoration: BoxDecoration(
                        color: Color(0xFF25282C),
                      ),
                      alignment: AlignmentDirectional(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, -0.75),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 40, 0, 0),
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
                                              color: Color(0xFF557294),
                                              fontSize: 15,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: AlignmentDirectional(0.65, 0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 0,
                                        buttonSize: 70,
                                        icon: Icon(
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
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
        bottomNavigationBar: bottomappbarCustom());
  }
}
