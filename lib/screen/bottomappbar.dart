import 'package:flutter/material.dart';
import 'package:musicapp/screen/homepage.dart';
import 'package:musicapp/screen/localplaylist.dart';
import 'package:musicapp/screen/searchpage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class bottomappbarCustom extends StatefulWidget {
  const bottomappbarCustom({super.key});

  @override
  State<bottomappbarCustom> createState() => _bottomappbarCustomState();
}

class _bottomappbarCustomState extends State<bottomappbarCustom> {

    @override
  void initState() {
    super.initState();
    List<bool> _selected = [true, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xFF40444A),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 25,
              borderWidth: 1,
              buttonSize: 60,
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePageWidget()));
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 25,
              borderWidth: 1,
              buttonSize: 60,
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchpageWidget()));
                ;
              },
            ),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 25,
              borderWidth: 1,
              buttonSize: 60,
              icon: const Icon(
                Icons.library_music_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const localplaylisttWidget()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
