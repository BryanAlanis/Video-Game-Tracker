import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_interactions_api/src/api/user_interactions_api.dart';
import 'package:user_interactions_api/src/models/user_interactions_model.dart';

class FireStoreUserInteractionsApi implements UserInteractionsApi {
  final database = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser?.email;
  
  @override
  Future<UserInteractions> getInteractions() async {
    try {
      final userDoc = await database.collection('users').doc('$currentUser').get();
      return UserInteractions.fromFireStore(userDoc);
    } catch (e) {
      throw const UserInteractionsException(message: 'Could not load user interactions');
    }
  }

  @override
  Future<void> upsertInteractions(UserInteractions interactions) async {
    try {
      await database.collection('users').doc('$currentUser').set(
        interactions.toFireStore()
      );
    } catch (e) {
      throw const UserInteractionsException(message: 'Could not update data');
    }
  }
}