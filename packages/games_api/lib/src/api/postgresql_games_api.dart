import 'dart:convert';

import 'package:games_api/src/api/games_api.dart';
import 'package:games_api/src/models/game.dart';
import 'package:http/http.dart' as http;

class PostgresqlGamesApi implements GamesApi {

  @override
  Future<List<GameModel>> getGames() async {
    final response = await http.get(Uri.parse('http://localhost:8080/games'));

    if (response.statusCode == 200) {

      final parsed = json.decode(response.body) as List;

      List<GameModel> games = parsed.map((game) => GameModel.fromJson(game)).toList();

      return games;
    }
    return [];
  }
}