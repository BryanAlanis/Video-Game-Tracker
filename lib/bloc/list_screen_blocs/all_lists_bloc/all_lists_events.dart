import 'package:equatable/equatable.dart';
import 'package:user_list_api/user_list_api.dart';

abstract class AllListsEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetListsEvent extends AllListsEvents {}

class AddListEvent extends AllListsEvents {
  final UserList list;

  AddListEvent({required this.list});

  @override
  List<Object?> get props => [list];
}

class UpdateListEvent extends AllListsEvents {
  final UserList list;

  UpdateListEvent({required this.list});

  @override
  List<Object?> get props => [list];
}

class DeleteListEvent extends AllListsEvents {
  final String listID;

  DeleteListEvent({required this.listID});

  @override
  List<Object?> get props => [listID];
}