import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/pages/edit_profile/edit_page.dart';
import 'package:devspectrum/pages/login.dart';
import 'package:devspectrum/resources/auth_methods.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/utils/follow_button.dart';
import 'package:devspectrum/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool isLoading = false;
  bool isFollowing = false;
  var userData = {};
  int postLength = 0;
  int followersLength = 0;

  int followingLength = 0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('Post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postsnap.docs.length;
      userData = Usersnap.data()!;
      followersLength = Usersnap.data()!['followers'].length;
      followingLength = Usersnap.data()!['following'].length;
      isFollowing = Usersnap.data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(err.toString(), context);
    }
  }

  @override
  void dispose() {
    biocontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async{
                      setState(() {
                        isLoading=true;
                      });
                     await AuthMethods().logout();
                     setState(() {
                       isLoading=false;
                     });
                   // ignore: use_build_context_synchronously
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen())) ;
                    },
                     child: const Text('Logout'),)
              ],
              title: Text(userData['username']),
            ),
            body: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['username'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userData['bio'],
                              style: const TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      postLength.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Projects',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      followersLength.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      followingLength.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Following',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FirebaseAuth.instance.currentUser!.uid != widget.uid
                          ? isFollowing
                              ? FollowButton(
                                function: ()async{
                               await   FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                               setState(() {
                                   isFollowing=false;
                                   followersLength--;
                                 });
                               },
                                  backgroundColor: Colors.black,
                                  borderColor: Colors.white,
                                  text: 'Unfollow',
                                  textColor: Colors.white)
                              : FollowButton(
                                function: ()async{
                                 await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                 setState(() {
                                   isFollowing=true;
                                   followersLength++;
                                 });
                                },
                                  backgroundColor: Colors.blue,
                                  borderColor: Colors.white,
                                  text: 'Follow',
                                  textColor: Colors.white)
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  // Expanded(child: GridView.builder(gridDelegate: const   SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (context,snapshot){

                  // }))
                ],
              ),
            ),
          );
  }
}
