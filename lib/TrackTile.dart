import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicapp/Models/Track.dart';

import '../MusicPlayer.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Map<String, dynamic> track;

  @override
  Widget build(BuildContext context) {
    Track? song = Track.fromMap(track);

    return ListTile(
      enableFeedback: false,
      onTap: () async {
        await context.read<MusicPlayer>().addNew(song);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: song.art != null
            ? Image.file(
                File(song.art!),
                width: 50,
                height: 50,
              )
            : Image.network(
                song.thumbnails.first.url,
                width: 45,
                height: 45,
                fit: BoxFit.fill,
                errorBuilder: ((context, error, stackTrace) {
                  return Image.asset("assets/images/song.png");
                }),
              ),
      ),
      title: Text(song.title,
          style: Theme.of(context)
              .primaryTextTheme
              .titleMedium
              ?.copyWith(overflow: TextOverflow.ellipsis)),
      subtitle: Text(
        song.artists.map((e) => e.name).toList().join(', '),
        style: const TextStyle(
          color: Color.fromARGB(255, 93, 92, 92),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onLongPress: () {},
    );
  }
}
