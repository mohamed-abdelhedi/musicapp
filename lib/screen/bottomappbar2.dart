import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/screen/homepage.dart';
import 'package:musicapp/screen/localplaylist.dart';
import 'package:musicapp/screen/searchpage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class bottomappbarCustom2 extends StatefulWidget {
  const bottomappbarCustom2({super.key});

  @override
  State<bottomappbarCustom2> createState() => _bottomappbarCustom2State();
}

class _bottomappbarCustom2State extends State<bottomappbarCustom2> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePageWidget(),
    SearchpageWidget(),
    localplaylisttWidget(),
  ];
  void _onItemTapped(int index) {
    setState(
      () {
        setState(() {
          _currentIndex = index;
          _selectedColor = Colors.white;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[_currentIndex]),
          ); // Change the color of the selected icon
        });
      },
    );
  }
  int _currentIndex = 0;
  Color _selectedColor = Colors.white;
  Color _unselectedColor = Colors.grey;

  //List<bool> _selected = [true, false, false];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: _selectedColor,
      unselectedItemColor: _unselectedColor,
      onTap: _onItemTapped,
      backgroundColor: Color(0xFF40444A),
      selectedFontSize: 15,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // selectedIconTheme: IconThemeData(color: Colors.white, size: 25),
      // selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_music_outlined,
          ),
          label: 'Playlist',
        ),
      ],
    );
  }
}
