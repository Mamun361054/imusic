class ApiProvider {

  static const String domain = 'https://www.dhakdol.com/api';

  static const String login = "$domain/auth/login";
  static const String registration = "$domain/auth/register";
  static const String resetPassword = "$domain/resetPassword";
  static const String fetchAlbum = "$domain/albums?sort_order=asc&keyword=&user_id=&page=";
  static const String fetchUserAlbum = "$domain/albums?sort_order=asc&keyword=&user_id=";
  static const String fetchTracks = "$domain/musics?keyword=&sort_order=asc&user_id=&page=";
  static const String fetchAlbumMedia = "$domain/musics/album";
  static const String dashboard = "$domain/discover";
  static const String fetchArtists = "$domain/artists?sort_order=asc&keyword=&user_id=&page=";
  static const String fetchArtistsMedia = "$domain/musics/artist";
  static const String allArtists = "$domain/artists";
  static const String allAlbums = "$domain/albums";
  static const String allGenres = "$domain/genres";
  static const String allMoods = "$domain/moods";
  static const String fetchTracksMedia = "$domain/musics";
  static const String getMediaTotalLikesAndCommentsViews = "$domain/getmediatotallikesandcommentsviews";
  static const String updateMediaTotalViews = "$domain/update_media_total_views";
  static const String likeUnlikeMedia = "$domain/like-unlike/music";
  static const String loadReplies = "$domain/loadreplies";
  static const String replyComment = "$domain/replycomment";
  static const String deleteReply = "$domain/deletereply";
  static const String editReply = "$domain/editreply";
  static const String reportComment = "$domain/reportcomment";
  static const String storeFcmToken = "$domain/storefcmtoken";
  static const String loadComments = "$domain/comments/music";
  static const String makeComment = "$domain/comments";
  static const String deleteComment = "$domain/deletecomment";
  static const String editComment = "$domain/editcomment";
  static const String fetchMoods = "$domain/moods?sort_order=asc&keyword=&user_id=&page=";
  static const String fetchMoodsMedia = "$domain/musics/mood";
  static const String addAlbums = "$domain/albums/upload";
  static const String fetchUploadSongData = "$domain/api/music/required-field-data";
  static const String uploadSongs = "$domain/musics/upload";
  static const String userUploadAlbums = "$domain/user-uploaded-albums";
  static const String search = "$domain/search";
  static const String fetchgenreMedia = "$domain/musics/genre";
  static const String ads = "$domain/advertisements";
  static const String profile = "$domain/profile";
  static const String updateProfile = "$domain/profile/update";
  static const String userSearch = "$domain/user-search";
  static const String createOpinion = "$domain/opinion/create";
  static const String opinions = "$domain/opinions";
}
