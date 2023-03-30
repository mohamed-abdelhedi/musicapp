import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicapp/provider/SearchProvider.dart';
import 'package:musicapp/TrackTile.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch({this.query = "", super.key});

  final String query;
  @override
  State<SongsSearch> createState() => _SongsSearchState();
}

class _SongsSearchState extends State<SongsSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SearchProvider>().searchSongs(widget.query);
    return !context.watch<SearchProvider>().songsLoaded
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: context.watch<SearchProvider>().songs.map((track) {
                return TrackTile(
                  track: track,
                );
              }).toList(),
            ),
          );
  }
}
