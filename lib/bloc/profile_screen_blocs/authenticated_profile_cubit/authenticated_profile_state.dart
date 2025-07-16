import 'package:equatable/equatable.dart';
import 'package:user_interactions_api/user_interactions_api.dart';

enum StateStatus {loading, loaded, error}

class AuthenticatedProfileState extends Equatable{
  final UserInteractions userInteractions;
  final StateStatus stateStatus;
  final String errorMessage;

  const AuthenticatedProfileState({
    required this.userInteractions,
    this.stateStatus = StateStatus.loading,
    this.errorMessage = ''
  });

  AuthenticatedProfileState copyWith({
    UserInteractions? userInteractions,
    StateStatus? stateStatus,
    String? errorMessage,
  }) {
    return AuthenticatedProfileState(
      userInteractions: userInteractions ?? this.userInteractions,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [userInteractions, stateStatus];
}