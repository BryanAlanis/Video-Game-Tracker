import 'package:equatable/equatable.dart';

///
/// A model class that define what a user looks like
/// for the purposes of this project.
///
class User extends Equatable {
  final String id;
  final String? name;
  final String? email;
  /// Link for user's profile picture
  final String? photo;

  const User({
    required this.id,
    this.name,
    this.email,
    this.photo
  });

  /// empty represents an unauthenticated user
  static const empty = User(id: '',);

  /// Returns whether the user is empty or not
  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;


  @override
  List<Object?> get props => [name, email, photo, id];


}