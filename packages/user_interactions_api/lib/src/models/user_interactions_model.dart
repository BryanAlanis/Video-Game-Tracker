import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserInteractions extends Equatable {
  final Set<int> likes;
  final Set<int> played;
  final Set<int> playLater;
  final Map<String, dynamic> ratings; /// <Game ID, Rating>

  const UserInteractions({
    required this.likes,
    required this.played,
    required this.playLater,
    required this.ratings
  });

  /// Get data from FireStore and return a UserInteractions object
  factory UserInteractions.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    if(data == null) return UserInteractions.empty();

    return UserInteractions(
      likes: Set<int>.from(data['likes']?.toSet() ?? {}),
      played: Set<int>.from(data['played']?.toSet() ?? {}),
      playLater: Set<int>.from(data['playLater']?.toSet() ?? {}),
      ratings: Map<String, dynamic>.from(data['ratings'] ?? {})
    );
  }

  factory UserInteractions.empty() {
    return const UserInteractions(
      likes: {},
      played: {},
      playLater: {},
      ratings: {}
    );
  }

  bool isGameLiked (int gameID) {
    return likes.contains(gameID);
  }

  bool isGamePlayed (int gameID) {
    return played.contains(gameID);
  }

  bool isGamePlayLater (int gameID) {
    return playLater.contains(gameID);
  }

  double gameRating (String gameID) {
    return ratings[gameID] ?? 0;
  }


  /// Convert these lists into a map that can be stores in FireStore
  Map<String, dynamic> toFireStore() {
    return {
      'likes': likes,
      'played': played,
      'playLater': playLater,
      'ratings': ratings
    };
  }

  UserInteractions copyWith({
    Set<int>? likes, Set<int>? played,
    Set<int>? playLater, Map<String, dynamic>? ratings
  }) {
    return UserInteractions(
      likes: likes ?? this.likes,
      played: played ?? this.played,
      playLater: playLater ?? this.playLater,
      ratings: ratings ?? this.ratings
    );
  }

  @override
  List<Object?> get props => [likes, played, playLater, ratings];
}