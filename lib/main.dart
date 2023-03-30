import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicapp/SearchScreen.dart';
import 'package:musicapp/localplaylist.dart';
import 'package:musicapp/provider/SearchProvider.dart';
import 'package:musicapp/provider/SearchScreens/SongsSearch.dart';
import 'package:musicapp/provider/song_model_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicapp/searchfunction.dart';
import 'package:musicapp/songsearch.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  await Hive.openBox('myfavourites');
  await Hive.openBox('settings');
  await Hive.openBox('search_history');
  await Hive.openBox('song_history');
  await Hive.openBox('downloads');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SongModelProvider()),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SearchfunctionCopyWidget());
  }
}
