
import 'package:devspectrum/utils/pageList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({super.key});

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {
  String username = "";
 int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     TextButton(
      //         onPressed: () async {
      //           await AuthMethods().logout();
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => const LoginScreen(),
      //             ),
      //           );
      //         },
      //         child: Text('Logout'))
      //   ],
      // ),
      body:  PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white),
         
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_rounded,
              color: (_page == 2) ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 3) ? Colors.white : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
