import 'package:equatable/equatable.dart';

abstract class EditListEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

///
/// Add a new list to firebase or update an existing list
///
class SubmitChangesEvent extends EditListEvents {}

///
/// Add a game to the list
///
class AddGameEvent extends EditListEvents {
  final int gameID;

  AddGameEvent(this.gameID);

  @override
  List<Object?> get props => [gameID];
}

///
/// Remove a game from the list
///
class RemoveGameEvent extends EditListEvents {
  final int gameID;

  RemoveGameEvent(this.gameID);

  @override
  List<Object?> get props => [gameID];
}

///
/// Change isRanked to the opposite value.
///
class UpdateIsRankedEvent extends EditListEvents {
  final bool newValue;

  UpdateIsRankedEvent(this.newValue);

  @override
  List<Object?> get props => [newValue];
}

///
/// Change the list's title
///
class UpdateTitleEvent extends EditListEvents {
  final String newTitle;

  UpdateTitleEvent(this.newTitle);

  @override
  List<Object?> get props => [newTitle];
}

///
/// Change the list's description
///
class UpdateDescriptionEvent extends EditListEvents {
  final String newDescription;

  UpdateDescriptionEvent(this.newDescription);

  @override
  List<Object?> get props => [newDescription];
}

///
/// Reset the status to initial
///
class ResetStatusEvent extends EditListEvents {
  ResetStatusEvent();

  @override
  List<Object?> get props => [];
}
