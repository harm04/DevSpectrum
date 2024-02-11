// import 'dart:typed_data';

// import 'package:devspectrum/providers/user_provider.dart';
// import 'package:devspectrum/resources/firestore_methods.dart';
// import 'package:devspectrum/utils/pickimage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// import '../models/user.dart';

// class EditPage extends StatefulWidget {
//   const EditPage({super.key});

//   @override
//   State<EditPage> createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   final _formkey = GlobalKey<FormState>();
// TextEditingController usernamecontroller = TextEditingController();
// TextEditingController biocontroller = TextEditingController();

//   Uint8List? _image;
//   void selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = im;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;
//     return GestureDetector(
//       onTap: ()=>FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//         ),
//         body: Form(
//           key: _formkey,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [

//                   Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       color: Colors.black,
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           Stack(
//                             children: [
//                               _image != null
//                                   ? CircleAvatar(
//                                       radius: 60,
//                                       backgroundImage: MemoryImage(_image!),
//                                     )
//                                   : CircleAvatar(
//                                       radius: 60,
//                                       backgroundImage: NetworkImage(user.photoUrl),
//                                     ),
//                               Positioned(
//                                   right: 10,
//                                   top: 75,
//                                   child: IconButton(
//                                     onPressed: () {
//                                       selectImage();
//                                       // uploadImage();
//                                     },
//                                     icon: const Icon(
//                                       Icons.add_a_photo,
//                                       size: 40,
//                                       color: Colors.yellow,
//                                     ),
//                                   ))
//                             ],
//                           ),
//                           TextFormField(
//                             initialValue: user.username,

//                             decoration: const InputDecoration(
//                               hintText: 'eg : David Malan',
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           TextFormField(
//                             initialValue: user.bio,

//                             decoration: const InputDecoration(
//                               hintText: 'eg : Flutter Dev',
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               // if (_image != null) {
//                               //   FirestoreMethods()
//                               //       .uploadImage('ProfileImage', _image!, false);
//                               //   FirestoreMethods().updateData(
//                               //       usernamecontroller.text, biocontroller.text);
//                               // } else {
//                               //   FirestoreMethods().updateData(
//                               //       usernamecontroller.text, biocontroller.text);
//                               // }

//                             },
//                             child: Container(
//                               height: 50,
//                               width: 100,
//                               decoration: const BoxDecoration(
//                                 color: Colors.blue,
//                               ),
//                               child: const Center(child: Text('upload')),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/pages/edit_profile/edit_photo.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.active) {
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      title: const Text('Update Profile'),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 62,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(user.photoUrl),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditPhoto()));
                                },
                                child: const Text(
                                  'Edit Profile image',
                                  style: TextStyle(color: Colors.blue),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'username:',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    // Text(
                                    //   user.username,
                                    //   style: const TextStyle(fontSize: 17),
                                    // ),
                                    AutoSizeText.rich(TextSpan(children: [
                                      TextSpan(
                                          text: user.username,
                                          style: const TextStyle(fontSize: 17)),
                                    ]))
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      editUsername(user.username);
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'add bio:',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      overflow: TextOverflow.fade,
                                      user.bio,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      editBio(user.bio);
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<void> editUsername(String username) {
    usernamecontroller.text = username;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update username'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: usernamecontroller,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
              TextButton(
                  onPressed: () async {
                    String res = 'some error occured';
                    setState(() {
                      isLoading = true;
                    });
                    res = await FirestoreMethods()
                        .updateUsername(usernamecontroller.text);
                    if (res == 'success') {
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showSnackbar('username updated', context);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            ],
          );
        });
  }

  Future<void> editBio(String bio) {
    biocontroller.text = bio;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add bio'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    maxLines: null,
                    controller: biocontroller,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
              TextButton(
                  onPressed: () async {
                    String res = 'some error occured';
                    setState(() {
                      isLoading = true;
                    });
                    res =
                        await FirestoreMethods().updateBio(biocontroller.text);
                    if (res == 'success') {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                      showSnackbar('bio added', context);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            ],
          );
        });
  }
}
