import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/provider/SearchProvider.dart';
import 'package:musicapp/provider/SearchScreens/ArtistsSearch.dart';
import 'package:musicapp/provider/SearchScreens/PlaylistSearch.dart';
import 'package:musicapp/provider/SearchScreens/SongsSearch.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/services/YTMusic/ytmusic.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class searchList extends StatefulWidget {
  const searchList({Key? key}) : super(key: key);

  @override
  _searchListState createState() => _searchListState();
}

class _searchListState extends State<searchList>
    with AutomaticKeepAliveClientMixin<searchList>, TickerProviderStateMixin {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  bool submitted = false;
  List suggestions = [];
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  getSuggestions() async {
    if (mounted) {
      setState(() {
        submitted = false;
      });

      YTMUSIC.suggestions(textEditingController.text).then((value) {
        if (mounted) {
          setState(() {
            suggestions = value;
          });
        }
      });
    }
  }

  search(value) {
    if (value != null) {
      setState(() {
        submitted = true;
      });
      context.read<SearchProvider>().refresh();
      textEditingController.text = value;
      Box box = Hive.box('search_history');
      int index = box.values.toList().indexOf(textEditingController.text);
      if (index != -1) {
        box.deleteAt(index);
      }
      box.add(textEditingController.text);
    }
    setState(() {});
  }

  @override
  void dispose() {
    dispose();
    textController?.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFF25282C),
          body: SingleChildScrollView(
            child: SafeArea(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E3237),
                                  borderRadius: BorderRadius.circular(20),
                                  shape: BoxShape.rectangle,
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
                                            const AlignmentDirectional(0, 0),
                                        child: TextFormField(
                                          controller: textEditingController,
                                          autofocus: true,
                                          obscureText: false,
                                          // ignore: prefer_const_constructors
                                          decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText:
                                                  'Search song, artist, album',
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              )),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                          textAlign: TextAlign.start,
                                          textInputAction:
                                              TextInputAction.search,
                                          onChanged: (text) {
                                            getSuggestions();
                                          },
                                          onFieldSubmitted: (text) {
                                            search(text);
                                          },
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
                                  0, 10, 0, 0),
                              child: DefaultTabController(
                                length: 3,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    TabBar(
                                      labelColor: const Color(0xFF0685CE),
                                      unselectedLabelColor:
                                          const Color(0xFF244975),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                          ),
                                      indicatorColor: const Color(0xFF244975),
                                      tabs: [
                                        const Tab(
                                          text: 'Songs',
                                        ),
                                        const Tab(
                                          text: 'Artist',
                                        ),
                                        const Tab(
                                          text: 'Playlist',
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          SongsSearch(
                                              query:
                                                  textEditingController.text),
                                          ArtistsSearch(
                                              query:
                                                  textEditingController.text),
                                          PlaylistSearch(
                                              query:
                                                  textEditingController.text),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Expanded(
                                        child: ValueListenableBuilder(
                                            valueListenable:
                                                Hive.box('settings')
                                                    .listenable(),
                                            builder: (context, Box box, child) {
                                              return ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                itemCount: suggestions.length,
                                                itemBuilder: (context, index) {
                                                  String e = suggestions[index];

                                                  return ListTile(
                                                    enableFeedback: false,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 8,
                                                            vertical: 0),
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    leading: Icon(Icons.search,
                                                        color: Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyLarge
                                                            ?.color),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          textEditingController
                                                              .text = e;
                                                          submitted = false;
                                                        });
                                                      },
                                                      icon: Icon(
                                                          box.get('textDirection',
                                                                      defaultValue:
                                                                          'ltr') ==
                                                                  'rtl'
                                                              ? CupertinoIcons
                                                                  .arrow_up_right
                                                              : CupertinoIcons
                                                                  .arrow_up_left,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryTextTheme
                                                              .bodyLarge
                                                              ?.color),
                                                    ),
                                                    dense: true,
                                                    title: Text(
                                                      e,
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .bodyLarge,
                                                    ),
                                                    onTap: () {
                                                      search(e);
                                                    },
                                                  );
                                                },
                                              );
                                            }),
                                      ),
                                    )
                                  ],
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
          bottomNavigationBar: const bottomappbarCustom()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
