import 'package:user_list_api/src/api/firestore_user_list_api.dart';
import 'package:user_list_api/src/models/user_list.dart';

class UserListRepository {
  final FireStoreUserListApi _userListApi = FireStoreUserListApi();

  UserListRepository();

  /// Get a stream of this user's lists
  Stream<List<UserList>> getUserLists() => _userListApi.getLists();

  /// add a new list to the database
  Future<void> addList(UserList list) => _userListApi.addList(list);

  /// update an already existing list on the database
  Future<void> updateList(UserList list) => _userListApi.updateList(list);

  /// delete a list
  Future<void> deleteList(String listID) => _userListApi.deleteList(listID);
}