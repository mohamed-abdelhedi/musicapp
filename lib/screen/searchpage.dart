import 'package:get/get.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/screen/bottomappbar2.dart';
import 'package:musicapp/screen/searchList.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchpageWidget extends StatefulWidget {
  const SearchpageWidget({Key? key}) : super(key: key);

  @override
  _SearchpageWidgetState createState() => _SearchpageWidgetState();
}

class _SearchpageWidgetState extends State<SearchpageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController?.dispose();

    _unfocusNode.dispose();
    super.dispose();
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
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 30, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3237),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 15,
                                    borderWidth: 1,
                                    buttonSize: 60,
                                    icon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF565A5E),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      print('IconButton pressed ...');
                                    },
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const searchList()));
                                        },
                                        child: Text(
                                          'Search song, artist, album',
                                          //  autofocus: true,

                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Colors.grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 30, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 1,
                              decoration: const BoxDecoration(
                                color: Color(0xFF23262A),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 10, 20, 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Image.asset(
                                                'assets/images/rap.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
      bottomNavigationBar: bottomappbarCustom2(),
    );
  }
}
