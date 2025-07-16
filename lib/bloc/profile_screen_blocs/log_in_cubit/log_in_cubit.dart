import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/log_in_cubit/log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  final AuthenticationRepository _authenticationRepository;

  LogInCubit(this._authenticationRepository) : super(const LogInState());

  void emailChanged(String newEmail) {
    emit(state.copyWith(email: newEmail));
  }

  void passwordChanged(String newPassword) {
    emit(state.copyWith(password: newPassword));
  }

  Future<void> logIn() async {
    try {
      await _authenticationRepository.signIn(
        email: state.email, 
        password: state.password
      );
    } on SignInWithEmailAndPasswordException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
    catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}