import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_interactions_api/user_interactions_api.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/authenticated_profile_cubit/authenticated_profile_state.dart';
import 'package:games_api/games_api.dart';

class AuthenticatedProfileCubit extends Cubit<AuthenticatedProfileState>{
  final UserInteractionsRepository repository;
  final List<GameModel> games;

  AuthenticatedProfileCubit({
    required this.repository,
    required this.games,
  }) : super(
    AuthenticatedProfileState(userInteractions: UserInteractions.empty())
  );

  Future<void> getInteractions() async {
    try {
      UserInteractions interactions = await repository.getInteraction();

      emit(state.copyWith(
        userInteractions: interactions,
        stateStatus: StateStatus.loaded
      ));
    } catch (e) {
      emit(state.copyWith(
        stateStatus: StateStatus.error,
        errorMessage: 'An error occurred when getting your lists.'
            '\nTry again later.'
      ));
    }
  }

  ///
  /// Find the game with a matching ID and return the list as a [GameModel] list
  ///
  List<GameModel> getLikes() {
    return games.where((game) =>
        state.userInteractions.likes.contains(game.id)).toList();
  }

  List<GameModel> getPlayed() {
    return games.where((game) =>
        state.userInteractions.played.contains(game.id)).toList();
  }

  List<GameModel> getPlayLater() {
    return games.where((game) =>
        state.userInteractions.playLater.contains(game.id)).toList();
  }

  List<GameModel> getRatings() {
    return games.where((game) =>
        state.userInteractions.ratings.containsKey("${game.id}")).toList();
  }
}