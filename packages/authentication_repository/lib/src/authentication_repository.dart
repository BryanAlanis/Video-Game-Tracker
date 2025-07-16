import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentication_repository/src/models/user_model.dart' as my_user;

///
/// AuthRepository
///
/// Responsible for handling the authentication process with FireBase.
/// Handles the sign up and sign in.
///
/// Throws an exception if there is an error when signing up or signing in.
/// The error is caught by the bloc and shown to the user.
///
class AuthenticationRepository {
  final _database = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  ///
  /// Return the current user.
  ///
  my_user.User get currentUser {
    final currentUser = _firebaseAuth.currentUser;

    /// return an empty user if user is unauthenticated
    if(currentUser == null) {
      return my_user.User.empty;
    }

    return my_user.User(
      id: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      photo: currentUser.photoURL,
    );
  }

  ///
  /// Get the user stream.
  /// Notifies about any user changes including name, email,
  /// authentication changes, etc.
  ///
  Stream<my_user.User> get userStream {
    return _firebaseAuth.userChanges().map((firebaseUser) {
        if (firebaseUser == null) {
          return my_user.User.empty;
        }

        return my_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          name: firebaseUser.displayName,
          photo: firebaseUser.photoURL
        );
      }
    );
  }

  ///
  /// signUp
  /// Create an account with an email and password
  ///
  Future<void> signUp ({
    required String email,
    required String password,
    required String name
  }) async {
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await _firebaseAuth.currentUser?.updateDisplayName(name);

      /// Create a new document for this user in the database.
      /// Doc ID is their email and the necessary fields are given
      /// Documents can't be blank in FireStore so give fields with a value
      /// of 0 to make sure the document isn't deleted by the system.
      final data = {
        'userID': _firebaseAuth.currentUser?.uid,
      };

      /// add the initial data to firestore
      await _database.collection('users').doc(
          _firebaseAuth.currentUser?.email.toString()).set(data);

    } on FirebaseAuthException catch(e) {
      throw SignUpWithEmailAndPasswordException.fromCode(e.code);
    }
    catch(e){
      throw const SignUpWithEmailAndPasswordException();
    }
  }

  ///
  /// signIn
  /// Enter an already existing account
  ///
  Future<void> signIn ({required String email, required String password}) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch(e){
      throw SignInWithEmailAndPasswordException.fromCode(e.code);
    }
    catch(e){
      throw const SignInWithEmailAndPasswordException();
    }
  }

  ///
  /// Logout the user
  ///
  Future<void> logOut () async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw const LogOutException();
    }
  }

  ///
  /// Update the user's profile picture
  ///
  Future<void> updateProfilePicture (String url) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.updatePhotoURL(url);
    } catch (e) {
      throw const ProfilePictureException();
    }
  }

  ///
  /// Update the display name
  ///
  Future<void> updateName (String newName) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.updateDisplayName(newName);
    } catch (e) {
      throw const UpdateDisplayNameException();
    }
  }

  ///
  /// updateEmail
  ///
  /// Updates the primary email. Throws an exception if any errors
  /// occur during the process.
  ///
  /// User must be re-authenticated before updating email.
  ///
  Future<void> updateEmail (String newEmail, String password) async {
    try {
      if(password.isEmpty) {
        throw Exception('Password can\'t be empty');
      }
      final user = _firebaseAuth.currentUser;

      final credential = EmailAuthProvider.credential(
          email: user?.email ?? '',
          password: password
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.verifyBeforeUpdateEmail(newEmail);

    } on FirebaseAuthException catch (e) {
      throw ReAuthenticateWithCredentialException.fromCode(e.code);
    } catch (e) {
      throw const ReAuthenticateWithCredentialException();
    }
  }

  ///
  /// deleteAccount
  ///
  /// Deletes this user's account.
  /// A password is required before deleting.
  ///
  Future<void> deleteAccount (String password) async {
    try {
      if (password.isEmpty) {
        throw Exception('Please enter your password');
      }

      final user = _firebaseAuth.currentUser;

      final credential = EmailAuthProvider.credential(
          email: user?.email ?? '',
          password: password
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.delete();

    } on FirebaseAuthException catch (e) {
      throw ReAuthenticateWithCredentialException.fromCode(e.code);
    } catch (e) {
      throw const ReAuthenticateWithCredentialException();
    }
  }
}

class SignUpWithEmailAndPasswordException implements Exception {
  final String message;

  const SignUpWithEmailAndPasswordException({
    this.message = 'Unknown Error'
  });

  factory SignUpWithEmailAndPasswordException.fromCode(String code) {
    if (code == 'invalid-email') {
      return const SignUpWithEmailAndPasswordException(
        message: 'Invalid email'
      );
    }
    else if (code == 'email-already-in-use') {
      return const SignUpWithEmailAndPasswordException(
        message: 'Email already in use'
      );
    }
    else if (code == 'weak-password') {
      return const SignUpWithEmailAndPasswordException(
        message: 'Weak password'
      );
    }
    return const SignUpWithEmailAndPasswordException();
  }
}

class SignInWithEmailAndPasswordException implements Exception {
  final String message;

  const SignInWithEmailAndPasswordException({
    this.message = 'Unknown Error'
  });

  factory SignInWithEmailAndPasswordException.fromCode(String code) {
    if (code == 'invalid-email') {
      return const SignInWithEmailAndPasswordException(
          message: 'Invalid email'
      );
    }
    else if (code == 'user-not-found') {
      return const SignInWithEmailAndPasswordException(
          message: 'There is no user with this email'
      );
    }
    else if (code == 'wrong-password') {
      return const SignInWithEmailAndPasswordException(
          message: 'Wrong password'
      );
    }
    return const SignInWithEmailAndPasswordException();
  }
}

class UpdateDisplayNameException implements Exception {
  final String message;

  const UpdateDisplayNameException ({
    this.message = 'Couldn\'t update display name at this time'
  });
}

class ReAuthenticateWithCredentialException implements Exception {
  final String message;

  const ReAuthenticateWithCredentialException({
    this.message = 'Unknown Error'
  });

  factory ReAuthenticateWithCredentialException.fromCode(String code) {
    if (code == 'invalid-email') {
      return const ReAuthenticateWithCredentialException(
          message: 'Invalid email'
      );
    }
    else if (code == 'email-already-in-use') {
      return const ReAuthenticateWithCredentialException(
          message: 'Email already in use'
      );
    }
    else if (code == 'wrong-password') {
      return const ReAuthenticateWithCredentialException(
          message: 'Wrong password'
      );
    }
    return const ReAuthenticateWithCredentialException();
  }
}

class LogOutException implements Exception {
  final String message;

  const LogOutException({
    this.message = 'There was an error when logging out.'
  });
}

class ProfilePictureException implements Exception {
  final String message;

  const ProfilePictureException({
    this.message = 'There was an error when updating the profile picture.'
  });
}