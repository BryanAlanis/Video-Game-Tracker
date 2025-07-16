import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/games_bloc/games_states.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/games_bloc/games_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesBloc extends Bloc<GameEvent, GamesState> {
  final GamesRepository _repository;

  GamesBloc(this._repository) : super(
      const GamesState(games: [], isLoading: true)) {

    on<LoadGamesEvent>((event, emit) async {
      /// The games are being loaded so emit this state to start
      /// The UI will show a loading screen
      emit(state.copyWith(games: state.games, isLoading: true));

      /// Get games from api
      final games = (await _repository.getGames());

      /// Tell the UI that the games have been loaded
      emit(state.copyWith(games: games, isLoading: false));
    });
  }

  ///
  /// Get full game content ([name], [cover], [releaseYear], etc.) from [gameIDs].
  ///
  /// Helper method used primarily by the [lists] section of the app.
  /// [UserList]s store gameIDs only use less storage.
  ///
  List<GameModel> getGamesFromID(List<int> gameIDs) {
    List<GameModel> games = [];

    for(int gameID in gameIDs) {
      games.add(state.games.where((element) => element.id == gameID).first);
    }

    return games;
  }

  GameModel getSingleGameFromID(int gameID) {
    for(GameModel game in state.games) {
      if (game.id == gameID) {
        return game;
      }
    }

    /// Return first game in list if ID not found
    return state.games[0];
  }
}