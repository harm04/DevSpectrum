
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
      String profImg, String caption,String github,String projectName, List<File> selectedScreenshots) async {
    String res = 'some error occured';
String pId = Uuid().v1();
    try {
      String photoUrl =
          await StorageMethods().uploadPostToStorage('Post', file, pId,);
      
      Post post = Post(
          caption: caption,
          projectName: projectName,
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

  
Future<String> postComment (String profImg,String name,String text,String postId,String uid)async {
  String res ='some error occured';
try{
  
  if(text.isNotEmpty){
    String commentId = Uuid().v1();
    await _firestore.collection('Post').doc(postId).collection("comments").doc(commentId).set({
      'profImg':profImg,
      'uid':uid,
      'comment':text,
      'datePublished':DateTime.now(),
      'commentId':commentId,
      'name':name,
      'likes':[],
    });
    res ='success';
  } else{
    res= 'Please enter some text';
  }
} catch(err){
  res = err.toString();
}
return res;
}

 Future<String> likeComment(String postId,String commentId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('Post').doc(postId).collection('comments').doc(commentId).update({
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

  Future<String> deletePost(String postId)async{
    String res = 'some error occured';
    try{
      await _firestore.collection('Post').doc(postId).delete();
      res = 'success';
    } catch(err){
      res = err.toString();
    }
    return res;
  }


Future<void> followUser(String uid,String followId)async{
  try{
   DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();
   List following = (snap.data()! as dynamic)['following'];
   if(following.contains(followId)){
    await _firestore.collection('Users').doc(followId).update({
      'followers':FieldValue.arrayRemove([uid])
    });

    await _firestore.collection('Users').doc(uid).update({
      'following':FieldValue.arrayRemove([followId])
    });
   }  else{
    await _firestore.collection('Users').doc(followId).update({
      'followers':FieldValue.arrayUnion([uid])
    });
    await _firestore.collection('Users').doc(uid).update({
      'following':FieldValue.arrayUnion([followId])
    });
   }
  } catch(err){
print(err.toString());
  }
}
}
