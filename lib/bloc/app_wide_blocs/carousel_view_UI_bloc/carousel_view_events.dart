class CarouselViewEvent {}

class LoadInteractionsEvent extends CarouselViewEvent {
  final int initialGameID, initialIndex;

  LoadInteractionsEvent(this.initialGameID, this.initialIndex);
}

///
/// Show the regular user interactions bar.
///
class ShowInteractionsBarEvent extends CarouselViewEvent {
  final int gameID, index;

  ShowInteractionsBarEvent(this.gameID, this.index);
}

///
/// Tell the UI to show a 5-star rating bar instead of the usual buttons.
/// This event is triggered when the user taps on the rate button in the
/// interaction bar.
///
class ShowRatingBarEvent extends CarouselViewEvent {
  final int gameID;

  ShowRatingBarEvent(this.gameID);
}

///
/// Update the index when the user swipes to a new game
///
class UpdateIndexEvent extends CarouselViewEvent {
  final int newIndex;

  UpdateIndexEvent(this.newIndex);
}

/************ Add gameID to user database events ************/

///
/// User liked a new game event
///
class LikeEvent extends CarouselViewEvent {
  final int gameID;

  LikeEvent(this.gameID);
}

///
/// User marked a game as played
///
class PlayedEvent extends CarouselViewEvent {
  final int gameID;

  PlayedEvent(this.gameID);
}

///
/// User marked a game as play later
///
class PlayLaterEvent extends CarouselViewEvent {
  final int gameID;

  PlayLaterEvent(this.gameID);
}

///
/// User marked a game as rated
///
class RateEvent extends CarouselViewEvent {
  final int gameID;
  final double rating;

  RateEvent(this.gameID, this.rating);
}

/************ Remove gameID from user database events ************/

///
/// User unliked a game event
///
class RemoveLikeEvent extends CarouselViewEvent {
  final int gameID;

  RemoveLikeEvent(this.gameID);
}

///
/// User unmarked a game as played
///
class RemovePlayedEvent extends CarouselViewEvent {
  final int gameID;

  RemovePlayedEvent(this.gameID);
}

///
/// User unmarked a game as play later
///
class RemovePlayLaterEvent extends CarouselViewEvent {
  final int gameID;

  RemovePlayLaterEvent(this.gameID);
}

///
/// User unmarked a game as rated
///
class RemoveRatingEvent extends CarouselViewEvent {
  final int gameID;

  RemoveRatingEvent(this.gameID);
}