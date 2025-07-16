import 'package:equatable/equatable.dart';
import 'package:user_interactions_api/user_interactions_api.dart';

enum StateStatus {
  loading,
  loaded,
  showInteractions,
  showRatingBar,
  error,
}

class CarouselViewState extends Equatable {
  final StateStatus status;
  final int index, gameID;
  final bool isLoggedIn, played, playLater, liked;
  final double rating;
  final UserInteractions interactions;

  const CarouselViewState ({
    this.status = StateStatus.loading,
    this.index = 0,
    this.gameID = 0,
    this.isLoggedIn = false,
    this.played = false,
    this.playLater = false,
    this.liked = false,
    this.rating = 0,
    required this.interactions,
  });

  CarouselViewState copyWith ({
    StateStatus? status,
    int? index,
    int? gameID,
    bool? isLoggedIn,
    bool? played,
    bool? playLater,
    bool? liked,
    double? rating,
    UserInteractions? interactions,
  }) {
    return CarouselViewState(
      status: status ?? this.status,
      index: index ?? this.index,
      gameID: gameID ?? this.gameID,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      played: played ?? this.played,
      playLater: playLater ?? this.playLater,
      liked: liked ?? this.liked,
      rating: rating ?? this.rating,
      interactions: interactions ?? this.interactions
    );
  }

  @override
  List<Object?> get props => [
    status,
    index,
    gameID,
    isLoggedIn,
    played,
    playLater,
    liked,
    rating,
    interactions
  ];
}