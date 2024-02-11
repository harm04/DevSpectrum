import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String ssId = Uuid().v1();
  String pId = Uuid().v1();
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      ref = ref.child(pId);
    }
   
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadMultipleImages(List<File> selectedScreenshots) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    List<File> images = selectedScreenshots;
    // Create a list of upload tasks
    List<UploadTask> uploadTasks = images.map((File image) {
      // Create a reference to the images directory
      Reference imageRef = storage
          .ref('Screenshots')
          .child(pId)
          .child(ssId)
          .child('${image.path.split('/').last}');

      // Upload the image
      UploadTask uploadTask = imageRef.putFile(image);

      // Listen for upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        // print('Upload progress: $progress%');
      });

      return uploadTask;
    }).toList();

    // Wait for all uploads to complete
    await Future.wait(uploadTasks);

    // Get the download URLs for each image
    List<String> urls =
        await Future.wait(uploadTasks.map((UploadTask uploadTask) async {
      return await (await uploadTask).ref.getDownloadURL();
    }));

    // Print the download URLs
    urls.forEach(print);

    //  String ssUid = DateTime.now().millisecondsSinceEpoch.toString();
    //  await _firestore.
  }

  // Future<void> ssUrlToFirestore()async{
  //   List<String> urls =[];
  //   urls =
  // }
}
