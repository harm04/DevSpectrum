import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/utils/snackbar.dart';
import 'package:devspectrum/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final snap;
  const CommentsPage({
    super.key,
    required this.snap,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController commentcontroller = TextEditingController();
 bool isLoading=false;
  @override
  void dispose() {
    super.dispose();
    commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Post')
              .doc(widget.snap['postId'])
              .collection('comments')
              .snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            } 
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index){
              return  CommentCard(snap:(snapshot.data! as dynamic).docs[index].data() ,);
            });
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  controller: commentcontroller,
                  decoration: InputDecoration(
                    hintText: 'Send comment as @${user.username}',
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading=true;
                  });
               String res =   await FirestoreMethods().postComment(
                      user.photoUrl,
                      user.username,
                      commentcontroller.text,
                      widget.snap['postId'],
                      user.uid);
                     setState(() {
                        commentcontroller.text="";
                     });
                    if(res=='success'){
                       setState(() {
                    isLoading=false;
                  });
                  showSnackbar('Posted', context);
                    } else {
                      showSnackbar(res, context);
                    }

                },
                child: const Text('Post')),
          ],
        ),
      )),
    );
  }
}
