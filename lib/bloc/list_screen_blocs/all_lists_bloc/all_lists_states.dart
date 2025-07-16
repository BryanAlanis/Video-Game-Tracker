import 'package:equatable/equatable.dart';
import 'package:user_list_api/user_list_api.dart';

class AllListsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListsLoading extends AllListsState {}

class ListsLoaded extends AllListsState {
  final List<UserList> lists;

  ListsLoaded(this.lists);

  @override
  List<Object?> get props => [lists];
}