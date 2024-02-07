import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
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
            
          ],
        ),
      ),
    );
  }
}
