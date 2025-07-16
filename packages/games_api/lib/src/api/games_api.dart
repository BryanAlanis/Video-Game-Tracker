import 'package:games_api/src/models/game.dart';

///
/// GamesApi
///
/// The interface for an api that provides information about games
///
abstract class GamesApi {
  const GamesApi();

  /// Provides a list of games
  Future<List<GameModel>> getGames();
}

class GetGamesException implements Exception {}