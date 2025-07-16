enum DeleteAccountStateStatus {initial, success, error}

class DeleteAccountState {
  final DeleteAccountStateStatus status;
  final String message, password;

  const DeleteAccountState({
    this.status = DeleteAccountStateStatus.initial,
    this.message = '',
    this.password = '',
  });

  DeleteAccountState copyWith({
    DeleteAccountStateStatus? status,
    String? message,
    String? password,
  }) {
    return DeleteAccountState(
        status: status ?? this.status,
        message: message ?? this.message,
        password: password ?? this.password,
    );
  }
}