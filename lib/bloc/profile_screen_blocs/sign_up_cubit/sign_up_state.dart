import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String email, password, name;
  final String? errorMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.name = 'Unknown user',
    this.errorMessage});

  SignUpState copyWith({
    String? email,
    String? password,
    String? name,
    String? errorMessage
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [email, password, name, errorMessage];
}