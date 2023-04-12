import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicapp/provider/SearchScreens/ArtistsSearch.dart';
import 'package:musicapp/provider/SearchScreens/PlaylistSearch.dart';
import 'package:musicapp/screen/bottomappbar.dart';
import 'package:musicapp/provider/SearchProvider.dart';
import 'package:musicapp/provider/SearchScreens/SongsSearch.dart';
import 'package:musicapp/services/YTMusic/ytmusic.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchfunctionWidget extends StatefulWidget {
  const SearchfunctionWidget({Key? key}) : super(key: key);

  @override
  _SearchfunctionWidgetState createState() => _SearchfunctionWidgetState();
}

class _SearchfunctionWidgetState extends State<SearchfunctionWidget>
    with
        AutomaticKeepAliveClientMixin<SearchfunctionWidget>,
        TickerProviderStateMixin {
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
            log(value.toString());
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
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF25282C),
        body: SingleChildScrollView(
          child: SafeArea(
              child: GestureDetector(
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
                                0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3237),
                                borderRadius: BorderRadius.circular(10),
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
                                    onPressed: () {},
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: TextField(
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search song, artist, album',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText2,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                                fontFamily: 'Poppins',
                                                color: Colors.white),
                                        textAlign: TextAlign.start,
                                        textInputAction: TextInputAction.search,
                                        onChanged: (text) {
                                          getSuggestions();
                                        },
                                        onSubmitted: (text) {
                                          search(text);
                                        },
                                        controller: textEditingController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Column(
                              children: [
                                TabBar(
                                  labelColor: const Color(0xFF0685CE),
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                  indicatorColor: const Color(0xFF244975),
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Song',
                                          style: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall
                                              : TextStyle(
                                                  color: Color(0xFF0685CE)),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Artist',
                                          style: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall
                                              : TextStyle(
                                                  color: Color(0xFF0685CE)),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Playlist',
                                          style: tabController?.index == 2
                                              ? Theme.of(context)
                                                  .primaryTextTheme
                                                  .displaySmall
                                              : TextStyle(
                                                  color: Color(0xFF0685CE)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: submitted
                              ? Expanded(
                                  child: TabBarView(
                                    //controller: tabController,
                                    children: [
                                      SongsSearch(
                                          query: textEditingController.text),
                                      ArtistsSearch(
                                          query: textEditingController.text),
                                      PlaylistSearch(
                                          query: textEditingController.text),
                                    ],
                                  ),
                                ) //provide search suggestions and history
                              : ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box('settings').listenable(),
                                  builder: (context, Box box, child) {
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: suggestions.length,
                                      itemBuilder: (context, index) {
                                        String e = suggestions[index];

                                        return ListTile(
                                          enableFeedback: false,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 0),
                                          visualDensity: VisualDensity.compact,
                                          leading: Icon(Icons.search,
                                              color: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyLarge
                                                  ?.color),
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                textEditingController.text = e;
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
                                                color: Theme.of(context)
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
                      ],
                    ),
                  ),
                )
              ]))),
        ),
        bottomNavigationBar: const bottomappbarCustom());
  }

  @override
  bool get wantKeepAlive => true;
}
