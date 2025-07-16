import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/update_email_bloc/update_email_state.dart';

class UpdateEmailCubit extends Cubit<UpdateEmailState> {
  final AuthenticationRepository repository;

  UpdateEmailCubit({
    required this.repository,
    String? initialEmail
  }) : super(UpdateEmailState(
      initialEmail: initialEmail ?? '',
      email: initialEmail ?? ''
  ));

  /// Used to enable the [save] button once the user edits the email
  /// text field
  void emailChanged(newEmail) {
    emit(state.copyWith(email: newEmail));
  }

  void passwordChanged(newPassword) {
    emit(state.copyWith(password: newPassword));
  }

  void updateEmail() async {
    if (state.email.isEmpty) {
      emit(state.copyWith(
          status: UpdateEmailStateStatus.error,
          message: 'Email can\'t be empty'
      ));
    }
    else if (state.password.isEmpty) {
      emit(state.copyWith(
          status: UpdateEmailStateStatus.error,
          message: 'Password can\'t be empty'
      ));
    }
    else {
      try {
        await repository.updateEmail(state.email, state.password);
        emit(state.copyWith(
          status: UpdateEmailStateStatus.success,
          initialEmail: state.email,
          message: 'Email changed successfully'
        ));
      } on ReAuthenticateWithCredentialException catch (e) {
        emit(state.copyWith(
            status: UpdateEmailStateStatus.error,
            message: e.message
        ));
      } catch (e) {
        emit(state.copyWith(
            status: UpdateEmailStateStatus.error,
            message: 'Unknown Error. Please try again later'
        ));
      }
    }
  }
}