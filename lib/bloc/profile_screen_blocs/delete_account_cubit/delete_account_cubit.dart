import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final AuthenticationRepository repository;

  DeleteAccountCubit({
    required this.repository,
  }) : super(const DeleteAccountState());

  void passwordChanged(newPassword) {
    emit(state.copyWith(password: newPassword));
  }

  void deleteAccount() async {
    if (state.password.isEmpty) {
      emit(state.copyWith(
          status: DeleteAccountStateStatus.error,
          message: 'Password can\'t be empty'
      ));
    }
    else {
      try {
        await repository.deleteAccount(state.password);

        emit(state.copyWith(
            status: DeleteAccountStateStatus.success,
            message: 'Account deleted'
        ));
      } on ReAuthenticateWithCredentialException catch (e) {
        emit(state.copyWith(
            status: DeleteAccountStateStatus.error,
            message: e.message
        ));
      } catch (e) {
        emit(state.copyWith(
            status: DeleteAccountStateStatus.error,
            message: 'Unknown Error. Please try again later'
        ));
      }
    }
  }
}