import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:musicapp/services/result.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State {
  late Result result;
  String url = "";
  String title = "";
  String thumb = "";
  String filesize_audio = "";
  String filesize_video = "";
  String audio = "";
  String audio_asli = "";
  String video = "";
  String video_asli = "";
  String progress = "";
  bool isLoading = false;
  String directory = "";

  final textController = TextEditingController();
  final padding = const EdgeInsets.all(8.0);
  var dio = Dio();

  Future getDownloadPath() async {
    Directory? directory;
    try {
      print('https://www.youtube.com/watch?v=3gNd1Ma-gss');
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory!.path;
  }

  Future downloadVideo(String url, String name, String format) async {
    getDownloadPath().then((value) {
      setState(() {
        isLoading = true;
        directory = value!;
      });
    });

    // final baseStorage = await getExternalStorageDirectory();
    await dio.download(url, directory + "/" + name + format,
        onReceiveProgress: (rec, total) {
      setState(() {
        isLoading = false;
        progress =
            "Downloading.. " + ((rec / total) * 100).toStringAsFixed(0) + "%";
      });
    });
    setState(() {
      if (progress.contains('100')) {
        progress = "Download Successful";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(8.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Downloader"),
      ),
      body: Center(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              Padding(
                padding: padding,
                child: Column(
                  children: [
                    Image.network(
                      thumb != ""
                          ? thumb
                          : "https://i.ibb.co/qYTFsDx/placeholder.png",
                      height: 150,
                      width: 150,
                    ),
                    Text('https://www.youtube.com/watch?v=3gNd1Ma-gss'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            downloadVideo(audio, title, ".mp3");
                          },
                          child: Row(
                            children: [
                              Text(
                                "MP3",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                filesize_audio,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            downloadVideo(video, title, ".mp4");
                          },
                          child: Row(
                            children: [
                              Text(
                                "MP4",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                filesize_video,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: padding,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: "Paste link youtubenya disini cantik",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          setState(() {
                            url = textController.text;
                            isLoading = true;
                          });
                          await Result.connectToApi(url).then((value) {
                            result = value;
                            setState(() {
                              title = result.title!;
                              thumb = result.thumb!;
                              filesize_audio = result.filesize_audio!;
                              filesize_video = result.filesize_video!;
                              audio = result.audio!;
                              audio_asli = result.audio_asli!;
                              video = result.video!;
                              video_asli = result.video_asli!;
                              isLoading = false;
                            });
                          });
                        },
                      )),
                  onSubmitted: (url) => Result.connectToApi(url).then((value) {
                    setState(() {
                      title = result.title!;
                      thumb = result.thumb!;
                      filesize_audio = result.filesize_audio!;
                      filesize_video = result.filesize_video!;
                      audio = result.audio!;
                      audio_asli = result.audio_asli!;
                      video = result.video!;
                      video_asli = result.video_asli!;
                    });
                  }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Text(progress),
            ],
          ),
        ),
      ),
    );
  }
}
