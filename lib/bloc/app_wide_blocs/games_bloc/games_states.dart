import 'package:equatable/equatable.dart';
import 'package:games_api/games_api.dart';

class GamesState extends Equatable {
  final List<GameModel> games;
  final bool isLoading;

  const GamesState({required this.games, required this.isLoading});

  GamesState copyWith({List<GameModel>? games, bool? isLoading}) {
    return GamesState(
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  List<Object?> get props => [games, isLoading];
}