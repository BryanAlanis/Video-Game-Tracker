import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/update_user_name_cubit/update_user_name_state.dart';

class UpdateUsernameCubit extends Cubit<UpdateUsernameState> {
  final AuthenticationRepository repository;

  UpdateUsernameCubit({
    required this.repository,
    String? initialName
  }) : super(UpdateUsernameState(
    initialName: initialName ?? '',
    name: initialName ?? ''
  ));

  /// Used to enable the [save] button once the user edits the name
  /// text field
  void nameChanged(newName) {
    emit(state.copyWith(name: newName));
  }

  void updateName(String newName) async {
    try {
      await repository.updateName(newName);
      emit(state.copyWith(
        status: UpdateUsernameStateStatus.success,
        initialName: newName,
        message: 'Name changed successfully'
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UpdateUsernameStateStatus.error,
        message: e.toString()
      ));
    }
  }
}