import 'package:user_list_api/src/models/user_list.dart';

///
/// UserListApi
/// The interface for an api that provides access to UserLists
///
abstract class UserListApi {
  const UserListApi();

  /// Provides a stream of UserLists
  Stream<List<UserList>> getLists();

  /// Update the contents of the given list
  Future<void> updateList(UserList list);

  /// Add a new list to the collection
  Future<void> addList(UserList list);

  /// Deletes the given list
  /// Throws an UserListNotFoundException if list is not found
  Future<void> deleteList(String listID);
}

class UserListNotFoundException implements Exception {}