import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logging/logging.dart';
import 'package:musicapp/flutter_flow/flutter_flow_icon_button.dart';
import 'package:musicapp/flutter_flow/flutter_flow_theme.dart';

import 'package:musicapp/screen/songoverviewonline.dart';

import 'package:musicapp/services/youtube_services.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:musicapp/provider/SearchProvider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:musicapp/widgets/TrackTile.dart';

class SongsSearch extends StatefulWidget {
  const SongsSearch({this.query = "", super.key});

  final String query;
  @override
  State<SongsSearch> createState() => _SongsSearchState();
}

final OnAudioQuery _audioQuery = OnAudioQuery();
final AudioPlayer _audioPlayer = AudioPlayer();
bool fetched = false;
List<Map> searchedList = [];
bool done = true;

class _SongsSearchState extends State<SongsSearch> {
  @override
  void initState() {
    super.initState();
  }

  playsong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("error parsing song");
    }
  }

  var yt = YoutubeExplode();
  // Future<String> getMusicVideo(songId) async {
  //   final manifest = await yt.videos.streamsClient.getManifest(songId);
  //   return manifest.muxed.last.url.toString();
  // }

  // String uri(songId) {
  //   return getMusicVideo(songId).toString();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger.root.info('calling youtube search');
    EasyThrottle.throttle(
        'my-debouncer', // <-- An ID for this particular debouncer
        Duration(milliseconds: 2000), // <-- The debounce duration
        () {
      YouTubeServices().fetchSearchResults(widget.query).then((value) {
        if (mounted) {
          setState(() {
            searchedList = value;
            fetched = true;
          });
        }
      });
    });
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: searchedList.map(
          (Map section) {
            if (section['items'] == null) {
              return const SizedBox();
            }
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 20,
                    bottom: 5,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (section['items'] as List).length,
                  itemBuilder: (context, idx) {
                    final itemType =
                        section['items'][idx]['type']?.toString() ?? 'Video';

                    return ListTile(
                      title: Text(
                        section['items'][idx]['title'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        section['items'][idx]['subtitle'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF40444A),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      leading: Card(
                        margin: EdgeInsets.zero,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            itemType == 'Artist' ? 50.0 : 7.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            // If the URL is the one causing the error, return a default image widget
                            if (url ==
                                'https://img.youtube.com/vi/gCYcHz2k5x0/maxresdefault.jpg') {
                              return Image.asset(
                                  'assets/images/musicartwork.png');
                            }
                            // Otherwise, return a generic error widget
                            else {
                              return Icon(Icons.error);
                            }
                          },
                          imageUrl: section['items'][idx]['secondImage'],
                          // imageUrl: section['items'][idx]['image'],
                          placeholder: (
                            context,
                            url,
                          ) =>
                              const Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/musicartwork.png',
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        String songid = section['items'][idx]['id'];
                        final manifest =
                            await yt.videos.streamsClient.getManifest(songid);
                        String songurl = manifest.muxed.last.url.toString();

                        await _audioPlayer.setAudioSource(AudioSource.uri(
                          Uri.parse(songurl),
                          tag: MediaItem(
                            id: section['items'][idx]['id'],
                            album: section['items'][idx]['album'],
                            title: section['items'][idx]['title'],
                            artUri: Uri.parse(section['items'][idx]['image'] ??
                                section['items'][idx]['secondImage']),
                          ),
                        ));
                        _audioPlayer.play();

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SongoverviewWidgetonline(
                                      playlist: [section['items'][idx]],
                                      index: idx,
                                      player: _audioPlayer,
                                    )));
                      },
                    );
                  },
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
