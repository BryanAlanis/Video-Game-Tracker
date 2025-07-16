import 'package:user_interactions_api/src/models/user_interactions_model.dart';

abstract class UserInteractionsApi {
  const UserInteractionsApi();

  /// Get the user interactions for the current user
  Future<UserInteractions> getInteractions();

  /// Update existing list or insert a new list
  Future<void> upsertInteractions(UserInteractions interactions);
}

class UserInteractionsException implements Exception {
  final String message;

  const UserInteractionsException({
    this.message = 'Unknown Error'
  });
}