import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Directory? dir;
File file = File('');
final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
var yt = YoutubeExplode();
Future<void> downloadsong(dynamic index, dynamic path, dynamic fileName) async {
  double progress = 0;
  log(index.toString());

  final itemType = index['type']?.toString() ?? 'Video';
  String path1;
  var file = File('$path/$fileName');
  final file2 = File('$path/$fileName'.replaceAll('.webm', '.mp3'));

  // log(file.exists().toString());
  final video = await yt.videos.get(index['perma_url']);

  final manifest =
      await yt.videos.streamsClient.getManifest(index['perma_url']);
  final streams = manifest.audioOnly.first;
  final audio = streams;
  final audioStream = yt.videos.streamsClient.get(audio);

  await dir?.create(recursive: true);
  //final file = File('$path/$fileName');
  if (File('$path/$fileName'.replaceAll('.webm', '.mp3')) == true) {
    if (progress == 100) {
      Fluttertoast.showToast(
        msg: 'already downloaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    }
    print('already downloaded');
  } else {
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    var len = audio.size.totalBytes;
    var count = 0;
    var msg = 'Downloading ${video.title}.${audio.container.name}';
    stdout.writeln(msg);
    await for (final data in audioStream) {
      count += data.length;

      progress = ((count / len) * 100).ceil().toDouble();

      print(progress);
      output.add(data);
    }
    await output.flush();
    await output.close();
    //classify()
    var filePath = '$path/$fileName';

    final String command =
        '-i $filePath -acodec libmp3lame ${filePath.replaceAll('.webm', '.mp3')}';

    _flutterFFmpeg.execute(command).then((rc) {
      if (rc == 0) {
        print('Conversion succeeded!');
      } else {
        print('Conversion failed with code $rc');
      }
    });
    await Future.delayed(Duration(seconds: 5));
    log(progress.toString());
    if (progress == 100) {
      Fluttertoast.showToast(
        msg: 'Download completed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    }
    //delete webm format
    if (filePath.endsWith('.webm') || filePath.endsWith('.mp4')) {
      file.delete();
    }
  }
  // var filePath = '$path/${fileName.replaceAll('.webm', '.mp3')}';
  // log(filePath);
  // String genre = await classify(filePath, fileName.replaceAll('.webm', '.mp3'));
  // log(genre);
  // String genref = genre.replaceAll('"', '');

  // if (genref != null) {
  //   Map<String, dynamic> data = {
  //     'id': index['id'],
  //     'name': index['title'],
  //     'yt_url': index['perma_url'],
  //     'duration': index['duration'],
  //     'img_url': index['secondImage']
  //   };

  //   CollectionReference collectionRef =
  //       FirebaseFirestore.instance.collection(genref);

  //   DocumentReference documentRef = collectionRef.doc(index['title']);

  //   documentRef
  //       .set(data)
  //       .then((value) => print('Document added successfully!'))
  //       .catchError((error) => print('Failed to add document: $error'));
  // }
}
