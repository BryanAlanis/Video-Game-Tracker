import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {}

class LoadGamesEvent extends GameEvent {
  @override
  List<Object?> get props => [];
}