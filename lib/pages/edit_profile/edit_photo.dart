import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/pages/edit_profile/edit_page.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/utils/pickimage.dart';
import 'package:devspectrum/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPhoto extends StatefulWidget {
  const EditPhoto({super.key});

  @override
  State<EditPhoto> createState() => _EditPhotoState();
}

class _EditPhotoState extends State<EditPhoto> {
  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      String res = 'some error occured';
                      res = await FirestoreMethods()
                          .uploadImage('ProfileImage', _image!, false);
                      if (res == 'success') {
                        setState(() {
                          isLoading = false;
                        });
                        showSnackbar('photo updated successfully', context);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const EditPage())));
                                
                      }
                    },
                    child: const Text('Save'))
              ],
              automaticallyImplyLeading: true,
            ),
            body: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.white,
                    child: _image == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.photoUrl))
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(_image!),
                          ),
                  ),
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

                  // TextButton(
                  //     onPressed: () {
                  //       selectFromGallery();
                  //     },
                  //     child: const Text('Choose from gallery',
                  //         style: TextStyle(color: Colors.white, fontSize: 17))),
                  //         const SizedBox(
                  //   height: 10,
                  // ),
                  // TextButton(
                  //     onPressed: () {
                  //       selectFromCamera();
                  //     },
                  //     child: const Text('Choose from camera',
                  //         style: TextStyle(color: Colors.white, fontSize: 17)))
                ],
              ),
            ),
          );
  }
}
