import 'package:games_api/src/api/firestore_games_api.dart';
import 'package:games_api/src/api/postgresql_games_api.dart';
import 'package:games_api/src/models/game.dart';

class GamesRepository {
  final FirestoreGamesApi _firestoreGamesApi = FirestoreGamesApi();
  final PostgresqlGamesApi _postgresqlGamesApi = PostgresqlGamesApi();

  GamesRepository();

  /// Get all games stored in the database
  Future<List<GameModel>> getGames() => _firestoreGamesApi.getGames();
}