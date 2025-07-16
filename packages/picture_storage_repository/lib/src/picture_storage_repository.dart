import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PictureStorageRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _storageReference  = FirebaseStorage.instance.ref('profile_pictures');

  Future<void> saveImage (File image) async {
    try {
      final imageRef = _storageReference
          .child('${_firebaseAuth.currentUser?.uid}/profile_picture.png');

      await imageRef.putFile(image);

      final myImageURL = await imageRef.getDownloadURL();

      _firebaseAuth.currentUser?.updatePhotoURL(myImageURL);
    } catch(e) {
      throw Exception(e.toString());
    }
  }
}