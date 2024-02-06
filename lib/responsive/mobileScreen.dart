import 'package:devspectrum/pages/login.dart';
import 'package:devspectrum/resources/auth_methods.dart';
import 'package:flutter/material.dart';
class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({super.key});

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: ()async{
           await AuthMethods().logout();
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen(),),);
          }, child: Text('Logout'))
        ],
      ),
      body: Center(child: Text('mobile')),
    );
  }
}