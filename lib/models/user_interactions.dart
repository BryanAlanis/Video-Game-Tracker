class UserInteractions {
  List<dynamic> likes = [];
  List<dynamic> played = [];
  List<dynamic> playLater = [];
  Map<String, dynamic> ratings = {};

  UserInteractions({
    required this.likes,
    required this.played,
    required this.playLater,
    required this.ratings
  });

  UserInteractions copyWith({
    List<dynamic>? likes, List<dynamic>? played,
    List<dynamic>? playLater, Map<String, dynamic>? ratings
  }) {
    return UserInteractions(
        likes: likes ?? this.likes,
        played: played ?? this.played,
        playLater: playLater ?? this.playLater,
        ratings: ratings ?? this.ratings
    );
  }
}