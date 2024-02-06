import 'package:devspectrum/pages/signup.dart';
import 'package:devspectrum/responsive/mobileScreen.dart';
import 'package:devspectrum/responsive/responsive_layout.dart';
import 'package:devspectrum/responsive/webScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBklUkszr9X2fouNOc8_Fbv4fqtFbRB73s",
            appId: "1:1055115213250:web:ef1018720115ef7501be5b",
            messagingSenderId: "1055115213250",
            projectId: "devspectrum-bf1e0",
            storageBucket: "devspectrum-bf1e0.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

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
          brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
       home:const SignUpScreen(),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: mobileScreenLayout(),
      //   webScreenLayout: webScreenLayout(),
      // ),
    );
  }
}
