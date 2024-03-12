import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/widgets/post_card.dart';
import 'package:flutter/material.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      backgroundColor:
         Colors.black,
      appBar:AppBar(
              backgroundColor: Colors.black,
              centerTitle: false,
              title: Image.asset('assets/logo/D.png'),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body:
       StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            reverse: false,
            
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}