import 'dart:io';

import 'package:devspectrum/pages/project_details/feed.dart';

import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/resources/storage_methods.dart';
import 'package:devspectrum/responsive/mobileScreen.dart';

import 'package:devspectrum/utils/pickimage.dart';
import 'package:devspectrum/utils/snackbar.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;
  TextEditingController captioncontroller = TextEditingController();
  TextEditingController githubcontroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    captioncontroller.dispose();
    githubcontroller.dispose();
  }

  // late CollectionReference imgRef;
  Uint8List? _image;
  void selectFromGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void selectFromCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  List<File> selectedScreenshots = [];
  void pickScreenshots() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> screenshots =
        await picker.pickMultiImage(imageQuality: 100);
    if (screenshots.isNotEmpty) {
      for (var i = 0; i < screenshots.length; i++) {
        selectedScreenshots.add(File(screenshots[i].path));
      }
      setState(() {});

      print('image selected: ' + selectedScreenshots.length.toString());
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  postProject(String uid, String username, String profImg) async {
    String res = 'some error occured';
    try {
      setState(() {
        isLoading = true;
      });
      res = await FirestoreMethods().uploadPost(_image!, uid, username, profImg,
          captioncontroller.text, githubcontroller.text,selectedScreenshots);
      // await StorageMethods().uploadMultipleImages(selectedScreenshots);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        clearImage();
        // ignore: use_build_context_synchronously
       await showSnackbar('post uploaded', context);
        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const mobileScreenLayout()));
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
            
          title: const Text('Post'),
          actions: [
            _image != null
                ? TextButton(
                    onPressed: () async {
                      await postProject(user.uid, user.username, user.photoUrl);
                      // ignore: use_build_context_synchronously
                      
                    },
                    child: const Text('Upload'))
                : const SizedBox()
          ],
        ),
        body: _image == null
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Choose photo from',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 14, 87, 184),
                        elevation: 20,
                        child: InkWell(
                          onTap: () => selectFromGallery(),
                          child: Container(
                            width: 150,
                            height: 60,
                            child: const Center(
                                child: Text(
                              'Gallery',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Card(
                        color: const Color.fromARGB(255, 14, 87, 184),
                        elevation: 20,
                        child: InkWell(
                          onTap: () => selectFromCamera(),
                          child: Container(
                            width: 150,
                            height: 60,
                            child: const Center(
                                child: Text(
                              'Camera',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? const LinearProgressIndicator(
                          color: Colors.blue,
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        controller: captioncontroller,
                        decoration:
                            const InputDecoration(hintText: 'Write a caption'),
                        maxLines: null,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        child: Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'add your github repository here.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  TextField(
                    controller: githubcontroller,
                    decoration: const InputDecoration(
                        hintText: 'eg:https://github.com/jhon/devspectrum',
                        hintStyle: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pickScreenshots();
                      },
                      child: const Text('Select screenshots')),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    child: selectedScreenshots.isEmpty
                        ? const Center(
                            child: Text('Please select screenshots'),
                          )
                        : GridView.builder(
                            itemCount: selectedScreenshots.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1),
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: kIsWeb
                                      ? Image.network(
                                          selectedScreenshots[index].path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          selectedScreenshots[index],
                                          fit: BoxFit.cover,
                                        ));
                            }),
                  ))
                ],
              ));
  }
}
