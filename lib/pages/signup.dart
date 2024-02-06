import 'package:flutter/material.dart';

import 'package:rive/rive.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
//     late SMITrigger failTrigger,successTrigger;
//     late SMIBool closeEyesBool,lookBool;
//     Artboard? artboard;
//     late StateMachineController? stateMachineController;

// @override
//   void initState() {
//     super.initState() ;
//     initArtboard();
//   }

  // initArtboard(){
  //     rootBundle.load('assets/rive/login.riv').then((value) {
  //       final file = RiveFile.import(value);
  //       final art =file.mainArtboard;
  //       stateMachineController=StateMachineController.fromArtboard(art, 'Login machine')!;
  //       if(stateMachineController!=null){
  //         art.addController(stateMachineController!);
  //       }
  //       setState(() {
  //         artboard=art;
  //       });
  //     });
  // }
FocusNode emailFocusNode =FocusNode();
TextEditingController emailcontroller = TextEditingController();
FocusNode passwordFocusNode =FocusNode();
TextEditingController passwordcontroller = TextEditingController();
FocusNode usernameFocusNode =FocusNode();
TextEditingController usernamecontroller = TextEditingController();
    StateMachineController? controller;
    SMIInput<bool>?isChecking;
    SMIInput<double>?numLook;
    SMIInput<bool>?isHandsUp;
    SMIInput<bool>?trigSuccess;
    SMIInput<bool>?trigFail;

    @override
  void initState() {
   super.initState();
   emailFocusNode.addListener(emailFocus);
   passwordFocusNode.addListener(passwordFocus);
    usernameFocusNode.addListener(usernameFocus);
  }
@override
  void dispose() {
   super.dispose();
  emailFocusNode.removeListener(emailFocus);
  passwordFocusNode.removeListener(passwordFocus);
  usernameFocusNode.removeListener(usernameFocus);
  }
  void emailFocus(){
    isChecking?.change(emailFocusNode.hasFocus);
  }
  void passwordFocus(){
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }
  void usernameFocus(){
    isChecking?.change(usernameFocusNode.hasFocus);
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 300,
              child: RiveAnimation.asset(
                'assets/rive/login.riv',
                fit: BoxFit.fitHeight,
                stateMachines:const ['Login Machine'],
                onInit: (artboard) {
                  controller =StateMachineController.fromArtboard(artboard,'Login Machine');
                  if(controller==null) return;
                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");

                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 39, 37, 37),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 20,top: 20),
                child: Column(
                  children: [
                    TextField(
                      focusNode: emailFocusNode,
                      controller: emailcontroller,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Enter email',
                        label: const Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                       onChanged: (value){
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      focusNode: passwordFocusNode,
                      controller: passwordcontroller,
                      obscureText: true,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        hintText: 'Enter password',
                        label: const Text('Password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                     
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      focusNode: usernameFocusNode,
                      controller: usernamecontroller,
                      obscureText: false,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Enter username',
                        label: const Text('Username'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                       onChanged: (value){
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Already an user?',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 17),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      
                      onTap: () {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        usernameFocusNode.unfocus();

                        
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                            child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
