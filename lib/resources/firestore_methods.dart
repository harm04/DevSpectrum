import 'dart:io';
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
      String profImg, String caption,String github,List<File> selectedScreenshots) async {
    String res = 'some error occured';
String pId = Uuid().v1();
    try {
      String photoUrl =
          await StorageMethods().uploadPostToStorage('Post', file, pId,);
      
      Post post = Post(
          caption: caption,
          github: github,
          postId: pId,
          datePublished: DateTime.now(),
          username: username,
          uid: uid,
          profImg: profImg,
          postUrl: photoUrl,
          likes: [],
          screenshots: []);

      await _firestore.collection('Post').doc(pId).set(
            post.toJson(),
          );
        List<String> urls=  await StorageMethods().uploadMultipleImages(selectedScreenshots, pId);
        await _firestore.collection('Post').doc(pId).update({
          'screenshots':FieldValue.arrayUnion(urls),
        });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

    Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('Post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('Post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  
}
