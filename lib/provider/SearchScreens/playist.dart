// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicapp/screen/playlistOnline.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class playlistsearch extends StatefulWidget {
  const playlistsearch({
    Key? key,
    required this.query,
  }) : super(key: key);
  final String query;
  @override
  State<playlistsearch> createState() => _playlistsearchState();
}

class _playlistsearchState extends State<playlistsearch> {
  @override
  void initState() {
    super.initState();
    searchplaylist();
  }

  var youtube = new YoutubeExplode();
  Future<List> searchplaylist() async {
    var videos = await youtube.search.searchContent(widget.query);

    var playlists = videos
        .where((result) => result is SearchPlaylist)
        .cast<SearchPlaylist>()
        .toList();

    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: searchplaylist(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: InkWell(
                      onTap: () async {
                        var videos = await youtube.playlists
                            .getVideos(snapshot.data![index].playlistId)
                            .toList();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => playlistonlinetWidget(
                                    playlist: videos,
                                    title: snapshot.data![index].playlistTitle
                                        .toString())));
                      },
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].playlistTitle.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Text(
                          '${snapshot.data![index].playlistVideoCount.toString()} songs ',
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
                          shape: RoundedRectangleBorder(),
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
                            imageUrl: snapshot.data![index].thumbnails[0].url
                                .toString(),

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
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
