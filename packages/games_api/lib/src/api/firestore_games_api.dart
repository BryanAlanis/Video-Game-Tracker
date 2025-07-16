import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:games_api/src/api/games_api.dart';
import 'package:games_api/src/models/game.dart';

class FirestoreGamesApi implements GamesApi {
  final database = FirebaseFirestore.instance;

  @override
  Future<List<GameModel>> getGames() async {
    QuerySnapshot snapshot = await database.collection('games').get();

    List<GameModel> allGames = [];

    /// [snapshot] contains a list of maps. Each map represents a game.
    ///
    /// This snippet of code parses each document in [snapshot] and
    /// converts it into a GameModel which is then added to a list
    for (var element in snapshot.docs) {
        allGames.add(GameModel.fromJson(element.data() as Map<String, dynamic>));
    }

    return allGames;
  }
}