import 'package:devspectrum/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({super.key, required this.mobileScreenLayout, required this.webScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,Constraints){
      if(Constraints.maxWidth>webscreen){
        return webScreenLayout;
      } else {
        return mobileScreenLayout;
      }
    });
  }
}