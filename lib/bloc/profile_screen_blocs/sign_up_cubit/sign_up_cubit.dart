import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  void nameChanged(String newName) {
    emit(state.copyWith(name: newName));
  }

  void emailChanged(String newEmail) {
    emit(state.copyWith(email: newEmail));
  }

  void passwordChanged(String newPassword) {
    emit(state.copyWith(password: newPassword));
  }

  Future<void> signUp() async {
    try {
      await _authenticationRepository.signUp(
          email: state.email,
          password: state.password,
          name: state.name
      );
    } on SignUpWithEmailAndPasswordException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}