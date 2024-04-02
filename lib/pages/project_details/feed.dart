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
              title: ShaderMask(
                shaderCallback: (Rect bounds) {
                  const gradient = LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 79, 0, 143), Color.fromARGB(255, 247, 108, 228),Color.fromARGB(255, 11, 94, 218),Color.fromARGB(255, 54, 73, 244)],
                  );
                            
                  // using bounds directly doesn't work because the shader origin is translated already
                  // so create a new rect with the same size at origin
                  return gradient.createShader(Offset.zero & bounds.size);
                },
                child: const Text(
                  'DevSpectrum',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white, // must be white for the gradient shader to work
                  ),
                ),
              ),
              // actions: [
              //   IconButton(
              //     icon: const Icon(
              //       Icons.messenger_outline,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {},
              //   ),
              // ],
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