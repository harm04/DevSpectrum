import 'package:flutter/material.dart';
class webScreenLayout extends StatefulWidget {
  const webScreenLayout({super.key});

  @override
  State<webScreenLayout> createState() => _webScreenLayoutState();
}

class _webScreenLayoutState extends State<webScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('web')),
    );
  }
}