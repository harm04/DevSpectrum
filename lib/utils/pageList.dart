import 'package:devspectrum/pages/add_post.dart';
import 'package:devspectrum/pages/project_details/feed.dart';
import 'package:devspectrum/pages/profile.dart';
import 'package:devspectrum/pages/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

 List<Widget> homeScreenItems=[
 const FeedScreen(),
  const searchPage(),
  const AddPost(),
  ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid,)
];