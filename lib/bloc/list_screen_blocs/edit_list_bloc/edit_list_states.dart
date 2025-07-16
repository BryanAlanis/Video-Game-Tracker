import 'package:equatable/equatable.dart';
import 'package:user_list_api/user_list_api.dart';

enum EditListStateStatus {initial, loading, success, failure}

class EditListState extends Equatable {
  final EditListStateStatus status;
  final UserList? initialList;
  final String title;
  final String description;
  final List<int> games;
  final bool isRanked;

  const EditListState({
    this.status = EditListStateStatus.initial,
    this.initialList,
    this.title = '',
    this.description = '',
    required this.games,
    this.isRanked = false
  });

  EditListState copyWith({
    UserList? initialList,
    EditListStateStatus? status,
    String? title,
    String? description,
    List<int>? games,
    bool? isRanked
  }) {
    return EditListState(
      status:  status ?? this.status,
      initialList: initialList ?? this.initialList,
      title: title ?? this.title,
      description: description ?? this.description,
      games: games ?? this.games,
      isRanked: isRanked ?? this.isRanked
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialList,
    title,
    description,
    games,
    isRanked
  ];
}
