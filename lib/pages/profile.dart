
import 'dart:typed_data';

import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/pages/edit_profile/edit_page.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/auth_methods.dart';
import 'package:devspectrum/resources/storage_methods.dart';
import 'package:devspectrum/utils/pickimage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool isLoading = false;
  

  @override
  void dispose() {
    biocontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  //   Uint8List? _image;
  // void selectImage() async {
  //   Uint8List im = await pickImage(ImageSource.gallery);
  //   setState(() {
  //     _image = im;
  //   });
  // }

  // void uploadImage()async{
  //   try{
  //   String photoUrl=  await StorageMethods().uploadImageToStorage('ProfileImage', _image!, false);
  //   }catch(err){}
  // }
  

  // void uploadImage() async {
  //   if (image != null) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     String res = await FirestoreMethods().UploadImage(file: image);
  //     if (res == 'success') {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       // ignore: use_build_context_synchronously
        
  //     } else {
  //      showSnackbar(res, context);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return Scaffold(
                  appBar: AppBar(
                    actions: [
                      TextButton(onPressed: ()=> AuthMethods().logout(), child: Text('Logout'))
                    ],
            title: Text(user.username),
                  ),
                  body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(user.username,style: const TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
              const  SizedBox(height: 10,),
                Text(user.bio,style:const TextStyle(fontSize: 17),),
                const  SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.purple),
                        child: const Center(child: Text('Follow')),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.05,
                    ),
                    GestureDetector(
                      onTap: (){
                        // showEditSection(user.photoUrl,context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPage()));
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.purple),
                        child: const Center(child: Text('Edit Profile')),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Divider(color:  Colors.white,thickness: 1,)
              ],
            ),
                  ),
                );
          }
        );
  }

  

  
}
