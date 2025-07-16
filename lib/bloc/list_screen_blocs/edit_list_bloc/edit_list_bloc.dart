import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list_api/user_list_api.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';

class EditListBloc extends Bloc<EditListEvents, EditListState> {
  final UserListRepository repository;

  EditListBloc({
    required this.repository,
    UserList? initialUserList
  }) : super(
      EditListState(
        initialList: initialUserList,
        title: initialUserList?.title ?? '',
        description: initialUserList?.description ?? '',
        games: initialUserList?.games ?? [],
        isRanked: initialUserList?.isRanked ?? false,
      )
  ) {
    on<AddGameEvent>(_addGame);
    on<RemoveGameEvent>(_removeGame);
    on<UpdateIsRankedEvent>(_updateIsRanked);
    on<UpdateTitleEvent>(_updateTitle);
    on<UpdateDescriptionEvent>(_updateDescription);
    on<SubmitChangesEvent>(_submitChanges);
    on<ResetStatusEvent>(_resetStatus);
  }

  /// Add a game to the game list
  void _addGame(AddGameEvent event, Emitter<EditListState> emit) {
    List<int> tempList = List.from(state.games);
    tempList.add(event.gameID);

    emit(state.copyWith(games: tempList));
  }

  /// Remove a game from the game list
  void _removeGame(RemoveGameEvent event, Emitter<EditListState> emit) {
    List<int> tempList = List.from(state.games);
    tempList.removeWhere((element) => element == event.gameID);

    emit(state.copyWith(games: tempList));
  }

  /// Update [isRanked] to the new value
  void _updateIsRanked(
    UpdateIsRankedEvent event,
    Emitter<EditListState> emit
  ) {
    emit(state.copyWith(isRanked: event.newValue));
  }

  /// Update the [title].
  /// Don't emit a new state since we don't want any widgets to change
  void _updateTitle(UpdateTitleEvent event, Emitter<EditListState> emit) {
    emit(state.copyWith(title: event.newTitle));
  }

  /// Update the description.
  void _updateDescription(
    UpdateDescriptionEvent event,
    Emitter<EditListState> emit
  ) {
    emit(state.copyWith(description: event.newDescription));
  }

  void _resetStatus(ResetStatusEvent event, Emitter<EditListState> emit) {
    emit(state.copyWith(status: EditListStateStatus.initial));
  }

  /// Add a new list or update an already existing list.
  /// A list can't be added if there is no title or list of games.
  void _submitChanges(SubmitChangesEvent event, Emitter<EditListState> emit) async {
    try {
      if (state.title == '' || state.games.isEmpty) {
        emit(state.copyWith(status: EditListStateStatus.failure));
      }
      else {
        final list = (state.initialList ?? UserList.empty()).copyWith(
            title: state.title,
            description: state.description,
            games: state.games,
            isRanked: state.isRanked
        );
        await repository.updateList(list);
        emit(state.copyWith(status: EditListStateStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: EditListStateStatus.failure));
      throw (e.toString());
    }
  }
}