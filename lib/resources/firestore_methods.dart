import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/models/post.dart';
import 'package:devspectrum/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String currentUser() {
    String currentUser = _auth.currentUser!.uid;
    return currentUser;
  }

  Future<String> uploadImage(
      String childName, Uint8List file, bool isPost) async {
    String res = 'some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage(childName, file, false,);
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
        'photoUrl': photoUrl,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateUsername(String username) async {
    String res = 'some error occured';

    await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
      'username': username,
    });
    res = 'success';

    return res;
  }

  Future<String> updateBio(String bio) async {
    String res = 'some error occured';

    await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
      'bio': bio,
    });
    res = 'success';

    return res;
  }

  Future<String> uploadPost(Uint8List file, String uid, String username,
      String profImg, String caption,String github) async {
    String res = 'some error occured';

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('Post', file, true,);
      String postId = const Uuid().v1();
      Post post = Post(
          caption: caption,
          github: github,
          postId: postId,
          datePublished: DateTime.now(),
          username: username,
          uid: uid,
          profImg: profImg,
          postUrl: photoUrl,
          likes: []);

      await _firestore.collection('Post').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
