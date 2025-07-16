import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

enum Status {authenticated, unauthenticated}

class AppAuthState extends Equatable {
  final Status appStatus;
  final User currentUser;

  const AppAuthState({
    required this.appStatus,
    this.currentUser = User.empty
  });

  @override
  List<Object?> get props => [appStatus, currentUser];
}