import 'package:user_interactions_api/src/api/firestore_user_interactions_api.dart';
import 'models/user_interactions_model.dart';

class UserInteractionsRepository {
  final FireStoreUserInteractionsApi _userInteractionsApi = FireStoreUserInteractionsApi();

  UserInteractionsRepository();

  Future<UserInteractions> getInteraction()
      => _userInteractionsApi.getInteractions();

  Future<void> upsertInteractions(UserInteractions interactions)
      => _userInteractionsApi.upsertInteractions(interactions);
}