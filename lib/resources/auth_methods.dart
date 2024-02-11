import 'package:devspectrum/models/user.dart' as models;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<models.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =await _firestore.collection('Users').doc(currentUser.uid).get();
    return models.User.fromSnap(snap);
  }

  //signup
  Future<String> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        models.User user = models.User(
            email: email,
            password: password,
            photoUrl:
                'https://as1.ftcdn.net/v2/jpg/05/34/22/36/1000_F_534223614_iJ0EyF0kZu8IMncyeLt80SVx6Fxv8Wnh.webp',
            username: username,
            uid: cred.user!.uid,
            bio: 'Hey I am using Devspectrum!');
            
        await _firestore
            .collection("Users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      } else {
        res = 'Please fill all the empty fields';
      }
      print(res);
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

//login
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fill all the empty fields';
      }
      print(res);
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

  //logout

  Future<String> logout() async {
    String res = 'some error occured';
    await _auth.signOut();
    res = 'success';
    return res;
  }

 
}
