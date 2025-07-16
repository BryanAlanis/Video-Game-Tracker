import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

///
/// UserList
///
/// Model for a user created list.
///
/// A list must have an [id], [title], and int list of [games] as IDs.
/// A [description] is optional. [isRanked] is used to determine if a
/// list is ranked or not. It defaults to false (not ranked).
///
/// [UserList.fromFireStore] and [toFireStore] help get and store data
/// to FireStore. [UserList]s are immutable so [copyWith] creates copies of this
/// object.
///
class UserList extends Equatable{
  final String id;
  final String title;
  final List<int> games;
  final String description;
  final bool isRanked;

  /// assign an ID to this list if none is given
  UserList({
    String? id,
    required this.title,
    required this.games,
    this.description = '',
    this.isRanked = false
  }) : id = id ?? const Uuid().v4();

  /// Get data from FireStore and return a UserList object
  factory UserList.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return UserList(
      id: data?['id'] as String,
      title: data?['title'] as String,
      games: List<int>.from(data?['games'] ?? []),
      description: data?['description'] as String,
      isRanked: data?['isRanked'] as bool
    );
  }

  /// Returns an empty UserList. Used when creating a new list
  factory UserList.empty() {
    return UserList(
      title: '',
      games: const [],
    );
  }

  /// Converts this UserList into a Map that can be stored in FireStore
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'games': games,
      'description': description,
      'isRanked': isRanked
    };
  }

  /// Copy this UserList and change any of the fields
  UserList copyWith({String? id, String? title, String? description,
    List<int>? games, bool? isRanked
  }) {
    return UserList(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        games: games ?? this.games,
        isRanked: isRanked ?? this.isRanked
    );
  }

  /// Used by Equatable to compare two UserList objects
  @override
  List<Object?> get props => [id, title, games, description, isRanked];
}