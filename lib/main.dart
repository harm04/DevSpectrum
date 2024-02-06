import 'package:devspectrum/pages/signup.dart';
import 'package:devspectrum/responsive/mobileScreen.dart';
import 'package:devspectrum/responsive/responsive_layout.dart';
import 'package:devspectrum/responsive/webScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     scaffoldBackgroundColor: Colors.black,
     appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
     brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
    //  home:const SignUpScreen(),
    home:const ResponsiveLayout(mobileScreenLayout: mobileScreenLayout(),webScreenLayout: webScreenLayout(),),
    );
  }
}
