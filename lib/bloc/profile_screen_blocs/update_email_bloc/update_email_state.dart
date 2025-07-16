enum UpdateEmailStateStatus {initial, success, error}

class UpdateEmailState {
  final UpdateEmailStateStatus status;
  final String message, email, password, initialEmail;

  const UpdateEmailState({
    this.status = UpdateEmailStateStatus.initial,
    this.message = '',
    this.email = '',
    this.password = '',
    required this.initialEmail
  });

  UpdateEmailState copyWith({
    UpdateEmailStateStatus? status,
    String? message,
    String? email,
    String? password,
    String? initialEmail
  }) {
    return UpdateEmailState(
      status: status ?? this.status,
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
      initialEmail: initialEmail ?? this.initialEmail
    );
  }
}