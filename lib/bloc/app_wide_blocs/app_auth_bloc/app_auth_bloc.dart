import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_event.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';

///
/// AppAuthBloc
///
/// Keep track of the authentication state throughout the whole app
///
class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userStream;

  AppAuthBloc(this._authenticationRepository) : super (
    _authenticationRepository.currentUser == User.empty
      ? const AppAuthState(appStatus: Status.unauthenticated)
      : AppAuthState(
          appStatus: Status.authenticated,
          currentUser: _authenticationRepository.currentUser
        )
  ) {

    /// Get the user stream and listen for any changes
    _userStream = _authenticationRepository.userStream.listen(
      (user) => add(UserChangedEvent(user: user))
    );

    ///
    /// Update the authentication status of the app
    ///
    on<UserChangedEvent>((event, emit) async {
      if(event.user.isEmpty) {
        emit(const AppAuthState(appStatus: Status.unauthenticated));
      }
      else {
        emit(AppAuthState(
          appStatus: Status.authenticated,
          currentUser: event.user)
        );
      }
    });

    ///
    /// Logout the user
    ///
    on<LogoutEvent>((event, emit) async {
      await _authenticationRepository.logOut();
    });
  }

  ///
  /// Close the stream
  ///
  @override
  Future<void> close() {
    _userStream.cancel();
    return super.close();
  }
}