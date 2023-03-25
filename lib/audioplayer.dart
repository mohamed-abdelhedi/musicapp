import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration position = Duration();
  Duration audioDuration = Duration();

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d;
      });
    });
    player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void play() async {
    await player.setSource(AssetSource('music/music.mp3'));
  }

  void pause() async {
    await player.pause();
  }

  void seek(Duration duration) {
    player.seek(duration);
  }

  String formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  Future<void> updatePosition() async {
    player.onPositionChanged
        .listen((Duration p) => {setState(() => position = p)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              formatDuration(position),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Slider(
              value: position.inMilliseconds.toDouble(),
              min: 0,
              max: audioDuration.inMilliseconds.toDouble(),
              onChanged: (double value) {
                seek(Duration(milliseconds: value.toInt()));
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        pause();
                      } else {
                        play();
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
