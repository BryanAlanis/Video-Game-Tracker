import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list_api/user_list_api.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/all_lists_bloc/all_lists_events.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/all_lists_bloc/all_lists_states.dart';

class AllListsBloc extends Bloc<AllListsEvents, AllListsState> {
  final UserListRepository repository;

  AllListsBloc({required this.repository}) : super(AllListsState()) {

    on<GetListsEvent>((event, emit) async {
      await emit.forEach(
        repository.getUserLists(),
        onData: (lists) => ListsLoaded(lists),
        onError: (error, stackTrace) {
          return ListsLoading();
        },
      );
    });

    on<AddListEvent>((event, emit) async {
      await repository.addList(event.list);
    });

    on<UpdateListEvent>((event, emit) async {
      await repository.updateList(event.list);
    });

    on<DeleteListEvent>((event, emit) async {
      await repository.deleteList(event.listID);
    });
  }
}