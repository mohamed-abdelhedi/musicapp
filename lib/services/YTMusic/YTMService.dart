import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:musicapp/services/YTMusic/ytmusic/nav.dart';

class YTMService {
  static const ytmDomain = 'music.youtube.com';
  static const httpsYtmDomain = 'https://music.youtube.com';
  static const baseApiEndpoint = '/youtubei/v1/';
  static const ytmParams = {
    'alt': 'json',
    'key': 'AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30'
  };
  static const userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0';
  Map<String, String> endpoints = {
    'search': 'search',
    'browse': 'browse',
    'get_song': 'player',
    'get_playlist': 'playlist',
    'get_album': 'album',
    'get_artist': 'artist',
    'get_video': 'video',
    'get_channel': 'channel',
    'get_lyrics': 'lyrics',
    'search_suggestions': 'music/get_search_suggestions',
  };
  static const filters = [
    'albums',
    'artists',
    'playlists',
    'community_playlists',
    'featured_playlists',
    'songs',
    'videos'
  ];
  List scopes = ['library', 'uploads'];

  Map<String, String>? headers;
  Map<String, dynamic>? context;

  YTMService();

  Map<String, String> initializeHeaders() {
    return {
      'user-agent': userAgent,
      'accept': '*/*',
      'accept-encoding': 'gzip, deflate',
      'content-type': 'application/json',
      'content-encoding': 'gzip',
      'origin': httpsYtmDomain,
      'cookie': 'CONSENT=YES+1'
    };
  }

  Future<Map> getAlbumDetails(String albumId) async {
    if (headers == null) {
      await init();
    }
    try {
      final body = Map.from(context!);
      body['browseId'] = albumId;
      final Map response =
          await sendRequest(endpoints['browse']!, body, headers);
      final String? heading =
          nav(response, [...headerDetail, ...titleText]) as String?;
      final String subtitle = joinRunTexts(
        nav(response, [...headerDetail, ...subtitleRuns]) as List? ?? [],
      );
      final String description = joinRunTexts(
        nav(response, [...headerDetail, ...secondSubtitleRuns]) as List? ?? [],
      );
      final List images = runUrls(
        nav(response, [...headerDetail, ...thumbnailCropped]) as List? ?? [],
      );
      final List finalResults = nav(response, [
            ...singleColumnTab,
            ...sectionListItem,
            ...musicShelf,
            'contents',
          ]) as List? ??
          [];
      final List<Map> songResults = [];
      for (final item in finalResults) {
        final String id = nav(item, mrlirPlaylistId).toString();
        final String image = nav(item, [
          mRLIR,
          ...thumbnails,
          0,
          'url',
        ]).toString();
        final String title = nav(item, [
          mRLIR,
          'flexColumns',
          0,
          mRLIFCR,
          ...textRunText,
        ]).toString();
        final List subtitleList = nav(item, [
              mRLIR,
              'flexColumns',
              1,
              mRLIFCR,
              ...textRuns,
            ]) as List? ??
            [];
        int count = 0;
        String year = '';
        String album = '';
        String artist = '';
        String albumArtist = '';
        String duration = '';
        String subtitle = '';
        year = '';
        for (final element in subtitleList) {
          // ignore: use_string_buffers
          subtitle += element['text'].toString();
          if (element['text'].trim() == '•') {
            count++;
          } else {
            if (count == 0) {
              if (element['text'].toString().trim() == '&') {
                artist += ', ';
              } else {
                artist += element['text'].toString();
                if (albumArtist == '') {
                  albumArtist = element['text'].toString();
                }
              }
            } else if (count == 1) {
              album += element['text'].toString();
            } else if (count == 2) {
              duration += element['text'].toString();
            }
          }
        }
        songResults.add({
          'id': id,
          'type': 'song',
          'title': title,
          'artist': artist,
          'genre': 'YouTube',
          'language': 'YouTube',
          'year': year,
          'album_artist': albumArtist,
          'album': album,
          'duration': duration,
          'subtitle': subtitle,
          'image': image,
          'perma_url': 'https://www.youtube.com/watch?v=$id',
          'url': 'https://www.youtube.com/watch?v=$id',
          'release_date': '',
          'album_id': '',
        });
      }
      return {
        'songs': songResults,
        'name': heading,
        'subtitle': subtitle,
        'description': description,
        'images': images,
        'id': albumId,
        'type': 'album',
      };
    } catch (e) {
      Logger.root.severe('Error in ytmusic getAlbumDetails', e);
      return {};
    }
  }

  Future<Map<String, dynamic>> getArtistDetails(String id) async {
    if (headers == null) {
      await init();
    }
    String artistId = id;
    if (artistId.startsWith('MPLA')) {
      artistId = artistId.substring(4);
    }
    try {
      final body = Map.from(context!);
      body['browseId'] = artistId;
      final Map response =
          await sendRequest(endpoints['browse']!, body, headers);
      // final header = response['header']['musicImmersiveHeaderRenderer']
      final String? heading =
          nav(response, [...immersiveHeaderDetail, ...titleText]) as String?;
      final String subtitle = joinRunTexts(
        nav(response, [...immersiveHeaderDetail, ...subtitleRuns]) as List? ??
            [],
      );
      final String description = joinRunTexts(
        nav(response, [...immersiveHeaderDetail, ...secondSubtitleRuns])
                as List? ??
            [],
      );
      final List images = runUrls(
        nav(response, [...immersiveHeaderDetail, ...thumbnails]) as List? ?? [],
      );
      final List finalResults = nav(response, [
            ...singleColumnTab,
            ...sectionList,
            0,
            ...musicShelf,
            'contents',
          ]) as List? ??
          [];
      final List<Map> songResults = [];
      for (final item in finalResults) {
        final String id = nav(item, mrlirPlaylistId).toString();
        final String image = nav(item, [
          mRLIR,
          ...thumbnails,
          0,
          'url',
        ]).toString();
        final String title = nav(item, [
          mRLIR,
          'flexColumns',
          0,
          mRLIFCR,
          ...textRunText,
        ]).toString();
        final List subtitleList = nav(item, [
              mRLIR,
              'flexColumns',
              1,
              mRLIFCR,
              ...textRuns,
            ]) as List? ??
            [];
        int count = 0;
        String year = '';
        String album = '';
        String artist = '';
        String albumArtist = '';
        String duration = '';
        String subtitle = '';
        year = '';
        for (final element in subtitleList) {
          // ignore: use_string_buffers
          subtitle += element['text'].toString();
          if (element['text'].trim() == '•') {
            count++;
          } else {
            if (count == 0) {
              if (element['text'].toString().trim() == '&') {
                artist += ', ';
              } else {
                artist += element['text'].toString();
                if (albumArtist == '') {
                  albumArtist = element['text'].toString();
                }
              }
            } else if (count == 1) {
              album += element['text'].toString();
            } else if (count == 2) {
              duration += element['text'].toString();
            }
          }
        }
        songResults.add({
          'id': id,
          'type': 'song',
          'title': title,
          'artist': artist,
          'genre': 'YouTube',
          'language': 'YouTube',
          'year': year,
          'album_artist': albumArtist,
          'album': album,
          'duration': duration,
          'subtitle': subtitle,
          'image': image,
          'perma_url': 'https://www.youtube.com/watch?v=$id',
          'url': 'https://www.youtube.com/watch?v=$id',
          'release_date': '',
          'album_id': '',
        });
      }
      return {
        'songs': songResults,
        'name': heading,
        'subtitle': subtitle,
        'description': description,
        'images': images,
        'id': artistId,
        'type': 'artist',
      };
    } catch (e) {
      Logger.root.info('Error in ytmusic getArtistDetails', e);
      return {};
    }
  }

  Future<Map> getPlaylistDetails(String playlistId) async {
    if (headers == null) {
      await init();
    }
    try {
      final browseId =
          playlistId.startsWith('VL') ? playlistId : 'VL$playlistId';
      final body = Map.from(context!);
      body['browseId'] = browseId;
      final Map response =
          await sendRequest(endpoints['browse']!, body, headers);
      final String? heading = nav(response, [
        'header',
        'musicDetailHeaderRenderer',
        'title',
        'runs',
        0,
        'text'
      ]) as String?;
      final String subtitle = (nav(response, [
                'header',
                'musicDetailHeaderRenderer',
                'subtitle',
                'runs',
              ]) as List? ??
              [])
          .map((e) => e['text'])
          .toList()
          .join();
      final String? description = nav(response, [
        'header',
        'musicDetailHeaderRenderer',
        'description',
        'runs',
        0,
        'text'
      ]) as String?;
      final List images = (nav(response, [
        'header',
        'musicDetailHeaderRenderer',
        'thumbnail',
        'croppedSquareThumbnailRenderer',
        'thumbnail',
        'thumbnails'
      ]) as List)
          .map((e) => e['url'])
          .toList();
      final List finalResults = nav(response, [
            'contents',
            'singleColumnBrowseResultsRenderer',
            'tabs',
            0,
            'tabRenderer',
            'content',
            'sectionListRenderer',
            'contents',
            0,
            'musicPlaylistShelfRenderer',
            'contents'
          ]) as List? ??
          [];
      final List<Map> songResults = [];
      for (final item in finalResults) {
        final String id = nav(item, [
          'musicResponsiveListItemRenderer',
          'playlistItemData',
          'videoId'
        ]).toString();
        final String image = nav(item, [
          'musicResponsiveListItemRenderer',
          'thumbnail',
          'musicThumbnailRenderer',
          'thumbnail',
          'thumbnails',
          0,
          'url'
        ]).toString();
        final String title = nav(item, [
          'musicResponsiveListItemRenderer',
          'flexColumns',
          0,
          'musicResponsiveListItemFlexColumnRenderer',
          'text',
          'runs',
          0,
          'text'
        ]).toString();
        final List subtitleList = nav(item, [
          'musicResponsiveListItemRenderer',
          'flexColumns',
          1,
          'musicResponsiveListItemFlexColumnRenderer',
          'text',
          'runs'
        ]) as List;
        int count = 0;
        String year = '';
        String album = '';
        String artist = '';
        String albumArtist = '';
        String duration = '';
        String subtitle = '';
        year = '';
        for (final element in subtitleList) {
          // ignore: use_string_buffers
          subtitle += element['text'].toString();
          if (element['text'].trim() == '•') {
            count++;
          } else {
            if (count == 0) {
              if (element['text'].toString().trim() == '&') {
                artist += ', ';
              } else {
                artist += element['text'].toString();
                if (albumArtist == '') {
                  albumArtist = element['text'].toString();
                }
              }
            } else if (count == 1) {
              album += element['text'].toString();
            } else if (count == 2) {
              duration += element['text'].toString();
            }
          }
        }
        songResults.add({
          'id': id,
          'type': 'song',
          'title': title,
          'artist': artist,
          'genre': 'YouTube',
          'language': 'YouTube',
          'year': year,
          'album_artist': albumArtist,
          'album': album,
          'duration': duration,
          'subtitle': subtitle,
          'image': image,
          'perma_url': 'https://www.youtube.com/watch?v=$id',
          'url': 'https://www.youtube.com/watch?v=$id',
          'release_date': '',
          'album_id': '',
          'expire_at': '0',
        });
      }
      return {
        'songs': songResults,
        'name': heading,
        'subtitle': subtitle,
        'description': description,
        'images': images,
        'id': playlistId,
        'type': 'playlist',
      };
    } catch (e) {
      Logger.root.severe('Error in ytmusic getPlaylistDetails', e);
      return {};
    }
  }

  Future<Response> sendGetRequest(
    String url,
    Map<String, String>? headers,
  ) async {
    final Uri uri = Uri.https(url);
    final Response response = await get(uri, headers: headers);
    return response;
  }

  Future<String?> getVisitorId(Map<String, String>? headers) async {
    final response = await sendGetRequest(ytmDomain, headers);
    final reg = RegExp(r'ytcfg\.set\s*\(\s*({.+?})\s*\)\s*;');
    final matches = reg.firstMatch(response.body);
    String? visitorId;
    if (matches != null) {
      final ytcfg = json.decode(matches.group(1).toString());
      visitorId = ytcfg['VISITOR_DATA']?.toString();
    }
    return visitorId;
  }

  Map<String, dynamic> initializeContext() {
    final DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    final String date = year + month + day;
    return {
      'context': {
        'client': {'clientName': 'WEB_REMIX', 'clientVersion': '1.$date.01.00'},
        'user': {}
      }
    };
  }

  Future<Map> sendRequest(
    String endpoint,
    Map body,
    Map<String, String>? headers,
  ) async {
    final Uri uri = Uri.https(ytmDomain, baseApiEndpoint + endpoint, ytmParams);
    final response = await post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map;
    } else {
      log('YtMusic returned ${response.statusCode}${response.body}');
      return {};
    }
  }

  dynamic nav(dynamic root, List items) {
    try {
      dynamic res = root;
      for (final item in items) {
        res = res[item];
      }
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<void> init() async {
    headers = initializeHeaders();
    if (!headers!.containsKey('X-Goog-Visitor-Id')) {
      headers!['X-Goog-Visitor-Id'] = await getVisitorId(headers) ?? '';
    }
    context = initializeContext();
  }
}
