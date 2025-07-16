import 'package:authentication_repository/authentication_repository.dart';

class AppAuthEvent {}

class LogoutEvent extends AppAuthEvent {}

class UserChangedEvent extends AppAuthEvent {
  final User user;

  UserChangedEvent({required this.user});
}