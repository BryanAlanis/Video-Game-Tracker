import 'package:user_interactions_api/user_interactions_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'carousel_view_events.dart';
import 'carousel_view_state.dart';


class CarouselViewBloc extends Bloc<CarouselViewEvent, CarouselViewState> {
  final UserInteractionsRepository repository;
  final bool isAuthenticated;

  CarouselViewBloc({
    required this.repository,
    required this.isAuthenticated
  }) : super(
      CarouselViewState(
        status: StateStatus.loading,
        isLoggedIn: isAuthenticated,
        interactions: UserInteractions.empty()
      )
  ) {
    on<LoadInteractionsEvent>(_loadInteractions);
    on<ShowInteractionsBarEvent>(_showInteractions);
    on<ShowRatingBarEvent>(_showRatingBar);
    on<LikeEvent>(_like);
    on<RemoveLikeEvent>(_removeLike);
    on<PlayedEvent>(_played);
    on<RemovePlayedEvent>(_removePlayed);
    on<PlayLaterEvent>(_playLater);
    on<RemovePlayLaterEvent>(_removePlayLater);
    on<RateEvent>(_rate);
    on<RemoveRatingEvent>(_removeRating);
  }

  ///
  /// Get interactions from database and show interactions for first game
  ///
  void _loadInteractions(
      LoadInteractionsEvent event,
      Emitter<CarouselViewState> emit) async
  {
    if (state.isLoggedIn) {
      try {
        emit(state.copyWith(status: StateStatus.loading));

        emit(state.copyWith(
            interactions: await repository.getInteraction(),
            status: StateStatus.loaded
        ));

        add(ShowInteractionsBarEvent(event.initialGameID, event.initialIndex));
      } catch(e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Show interactions for current game.
  ///
  /// Event parameters: game ID, index
  ///
  void _showInteractions(
      ShowInteractionsBarEvent event,
      Emitter<CarouselViewState> emit) async
  {
    emit(state.copyWith(
        status: StateStatus.showInteractions,
        liked: state.interactions.isGameLiked(event.gameID),
        played: state.interactions.isGamePlayed(event.gameID),
        playLater: state.interactions.isGamePlayLater(event.gameID),
        rating: state.interactions.gameRating(event.gameID.toString()),
        gameID: event.gameID,
        index: event.index
    ));
  }

  ///
  /// Show rating bar
  ///
  void _showRatingBar(
      ShowRatingBarEvent event,
      Emitter<CarouselViewState> emit) async
  {
    if (state.isLoggedIn) {
      emit(state.copyWith(
          status: StateStatus.showRatingBar,
          gameID: event.gameID
      ));
    }
  }

  ///
  /// Like a game. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _like(LikeEvent event, Emitter<CarouselViewState> emit) async {
    if (state.isLoggedIn) {
      try{
        state.interactions.likes.add(event.gameID);

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(liked: true));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Un-like a game. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _removeLike(RemoveLikeEvent event, Emitter<CarouselViewState> emit) async {
    if (state.isLoggedIn) {
      try{
        state.interactions.likes.remove(event.gameID);

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(liked: false));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Mark game as played. Unmark game as PlayLater. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _played(PlayedEvent event, Emitter<CarouselViewState> emit) async {
    if (state.isLoggedIn) {
      try{
        state.interactions.played.add(event.gameID);
        await repository.upsertInteractions(state.interactions);

        /// A game can't be both played and play later
        if(state.interactions.playLater.contains(event.gameID)) {
          state.interactions.playLater.remove(event.gameID);

          emit(state.copyWith(playLater: false, played: true));
        }
        else {
          emit(state.copyWith(played: true,));
        }
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Unmark game as played. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _removePlayed(
      RemovePlayedEvent event,
      Emitter<CarouselViewState> emit) async
  {
    if (state.isLoggedIn) {
      try{
        state.interactions.played.remove(event.gameID);

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(played: false));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Mark game as Play Later. Unmark game as played if it is marked.
  /// Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _playLater(PlayLaterEvent event, Emitter<CarouselViewState> emit) async {
    if (state.isLoggedIn) {
      try{
        state.interactions.playLater.add(event.gameID);
        await repository.upsertInteractions(state.interactions);

        /// A game can't be both played and play later
        if(state.interactions.played.contains(event.gameID)) {
          state.interactions.played.remove(event.gameID);
          emit(state.copyWith(played: false, playLater: true));
        }
        else {

          emit(state.copyWith(playLater: true));
        }
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Unmark game as Play Later. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _removePlayLater(
      RemovePlayLaterEvent event,
      Emitter<CarouselViewState> emit) async
  {
    if (state.isLoggedIn) {
      try{
        state.interactions.playLater.remove(event.gameID);

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(playLater: false));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Rate game. Update database and UI.
  ///
  /// Event parameters: rating(0-5) and game ID
  ///
  void _rate(RateEvent event, Emitter<CarouselViewState> emit) async {
    if (state.isLoggedIn) {
      try{
        state.interactions.ratings[event.gameID.toString()] = event.rating;

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(rating: event.rating));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }

  ///
  /// Remove rating. Update database and UI.
  ///
  /// Event parameters: game ID
  ///
  void _removeRating(
      RemoveRatingEvent event,
      Emitter<CarouselViewState> emit) async
  {
    if (state.isLoggedIn) {
      try{
        state.interactions.ratings.remove("${event.gameID}");

        await repository.upsertInteractions(state.interactions);

        emit(state.copyWith(rating: 0));
      } catch (e) {
        emit(state.copyWith(status: StateStatus.error));
      }
    }
  }
}