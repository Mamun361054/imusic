
import '../../model/opinion.dart';

class Media {
  final int? id, artistId, albumId, genreId;
  int? commentsCount, likesCount, previewDuration, duration, viewsCount;
  final String? title, coverPhoto, mediaType,durationInMin;
  final String? downloadUrl, streamUrl, source;
  final bool? canPreview, canDownload, isFree, http;
  bool? userLiked;
  String? artist, album, genre, lyrics;
  Opinions? opinions;

  Media({
    this.id,
    this.title,
    this.coverPhoto,
    this.mediaType,
    this.downloadUrl,
    this.source,
    this.canPreview,
    this.canDownload,
    this.isFree,
    this.userLiked,
    this.http,
    this.duration,
    this.commentsCount,
    this.likesCount,
    this.previewDuration,
    this.streamUrl,
    this.viewsCount,
    this.artistId,
    this.albumId,
    this.genreId,
    this.artist,
    this.album,
    this.genre,
    this.lyrics,
    this.durationInMin,
    this.opinions
  });

  static const String BOOKMARKS_TABLE = "bookmarks";
  static const String PLAYLISTS_TABLE = "media_playlists";
  static final bookmarkscolumns = [
    "id",
    "artistId",
    "albumId",
    "genreId",
    "title",
    "coverPhoto",
    "mediaType",
    "artist",
    "album",
    "genre",
    "lyrics",
    "downloadUrl",
    "canPreview",
    "canDownload",
    "isFree",
    "userLiked",
    "http",
    "duration",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];
  static final playlistscolumns = [
    "id",
    "playlistId",
    "artistId",
    "albumId",
    "genreId",
    "title",
    "coverPhoto",
    "mediaType",
    "artist",
    "album",
    "genre",
    "lyrics",
    "downloadUrl",
    "canPreview",
    "canDownload",
    "isFree",
    "userLiked",
    "http",
    "duration",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];

  factory Media.fromJson(Map<String, dynamic> json) {

    int id = int.parse(json['id'].toString());
    int artistId = json['artist_id'] != null ? int.parse(json['artist_id'].toString()):0;
    int albumId = json['album_id'] != null ? int.parse(json['album_id'].toString()):0;
    int genreId = json['genre_id'] != null ? int.parse(json['genre_id'].toString()):0;

    return Media(
        id: id,
        artistId: artistId,
        albumId: albumId,
        genreId: genreId,
        title: json['title'],
        coverPhoto: json['cover_photo'] != null ? json['cover_photo']: json['image'],
        mediaType: json['media_type'].toString(),
        artist: json['artist'],
        album: json['album'],
        genre: json['genre'],
        lyrics: json['lyrics'] != null ? json['lyrics']:'',
        downloadUrl: json['download'] ?? "",
        canPreview: json['can_preview'] != null ?  int.parse(json['can_preview'].toString()) == 1:true,
        canDownload: json['can_download'] != null ? int.parse(json['can_download'].toString()) == 1:true,
        isFree: json['is_free'] != null ? int.parse(json['is_free'].toString()) == 1 : true,
        userLiked: json['user_liked'] != null ? json['user_liked'] : false,
        http: true,
        duration: int.parse(json['duration'].toString()),
        commentsCount: json['comments_count'] != null
            ? int.parse(json['comments_count'].toString())
            : 0,
        likesCount: int.parse(json['likes_count'].toString()),
        streamUrl: json['stream'] ?? "",
        source: json['source'] != null ? json['source'] : "",
        durationInMin: json['duration_min'] ?? "0:00",
        opinions: Opinions.fromJson(json),
        viewsCount: int.parse(json['views_count'].toString()));
  }

  factory Media.fromMap(Map<dynamic, dynamic> data) {
    return Media(
      id: data['id'],
      artistId: data['artistId'],
      albumId: data['albumId'],
      genreId: data['genreId'],
      title: data['title'],
      coverPhoto: data['coverPhoto'],
      mediaType: data['mediaType'],
      artist: data['artist'],
      album: data['album'],
      genre: data['genre'],
      lyrics: data['lyrics'],
      downloadUrl: data['downloadUrl'],
      canPreview: int.parse(data['canPreview'].toString()) == 1,
      canDownload: int.parse(data['canDownload'].toString()) == 1,
      isFree: int.parse(data['isFree'].toString()) == 1,
      userLiked: int.parse(data['userLiked'].toString()) == 1,
      http: int.parse(data['http'].toString()) == 1,
      duration: data['duration'],
      commentsCount: data['commentsCount'],
      likesCount: data['likesCount'],
      previewDuration: data['previewDuration'],
      streamUrl: data['streamUrl'] ?? "",
      source: data['source'] ?? "",
      durationInMin: data['duration_min'] ?? "",
      viewsCount: data['viewsCount'],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "artistId": artistId,
        "albumId": albumId,
        "genreId": genreId,
        "title": title,
        "coverPhoto": coverPhoto,
        "mediaType": mediaType,
        "artist": artist,
        "album": album,
        "genre": genre,
        "lyrics": lyrics,
        "downloadUrl": downloadUrl,
        "canPreview": canPreview,
        "canDownload": canDownload,
        "isFree": isFree,
        "userLiked": userLiked,
        "http": http,
        "duration": duration,
        "commentsCount": commentsCount,
        "likesCount": likesCount,
        "previewDuration": previewDuration,
        "streamUrl": streamUrl,
        "source": source,
        "duration_min": durationInMin,
        "viewsCount": viewsCount
      };
}
