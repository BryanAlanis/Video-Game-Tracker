import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_list_api/src/models/user_list.dart';
import 'package:user_list_api/src/api/user_list_api.dart';

class FireStoreUserListApi extends UserListApi {
  final database = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser?.email;

  FireStoreUserListApi();

  @override
  Future<void> deleteList(String listID) async {
    try {
      final userDoc = database.collection('users').doc('$currentUser');
      userDoc.collection('lists').doc(listID).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<UserList>> getLists() async* {
    try {
      final userDoc = database.collection('users').doc('$currentUser');
      yield* userDoc.collection('lists')
          .snapshots()
          .map(
              (snapshot) => snapshot.docs.map(
                  (doc) => UserList.fromFireStore(doc)).toList()
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addList(UserList list) async {
    try {
      final userDoc = database.collection('users').doc('$currentUser');

      /// add() creates a new ID for this document/list
      userDoc.collection('lists').add(list.toFireStore());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateList(UserList list) async {
    try {
      final userDoc = database.collection('users').doc('$currentUser');

      /// set() replaces the contents of the document with the new contents
      userDoc.collection('lists').doc(list.id).set(list.toFireStore());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}