import 'package:equatable/equatable.dart';

class LogInState extends Equatable {

  final String email, password;
  final String? errorMessage;

  const LogInState({
    this.email = '',
    this.password = '',
    this.errorMessage
  });

  LogInState copyWith({
    String? email,
    String? password,
    String? errorMessage
  }) {
    return LogInState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [email, password, errorMessage];
}