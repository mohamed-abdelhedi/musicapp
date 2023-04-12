import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:musicapp/helper/logging.dart';
import 'package:musicapp/provider/SearchProvider.dart';

import 'package:musicapp/provider/song_model_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicapp/screen/localplaylist.dart';
import 'package:musicapp/screen/player_service.dart';
import 'package:musicapp/screen/tabbar.dart';
import 'package:musicapp/screen/welcoming.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// Future<void> startService() async {
//   await initializeLogging();
//   final AudioPlayerHandler audioHandler = await AudioService.init(
//     builder: () => AudioPlayerHandlerImpl(),
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.shadow.blackhole.channel.audio',
//       androidNotificationChannelName: 'BlackHole',
//       androidNotificationIcon: 'drawable/ic_stat_music_note',
//       androidShowNotificationBadge: true,
//       androidStopForegroundOnPause: false,
//       // Hive.box('settings').get('stopServiceOnPause', defaultValue: true) as bool,
//       notificationColor: Colors.grey[900],
//     ),
//   );
//   GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
// }

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
  await Hive.openBox('ytlinkcache');

  Future<void> openHiveBox(String boxName, {bool limit = false}) async {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      Logger.root.severe('Failed to open $boxName Box', error, stackTrace);
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      File dbFile = File('$dirPath/$boxName.hive');
      File lockFile = File('$dirPath/$boxName.lock');
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        dbFile = File('$dirPath/BlackHole/$boxName.hive');
        lockFile = File('$dirPath/BlackHole/$boxName.lock');
      }
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
    // clear box if it grows large
    if (limit && box.length > 500) {
      box.clear();
    }
  }

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
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: searchList());
  }
}
