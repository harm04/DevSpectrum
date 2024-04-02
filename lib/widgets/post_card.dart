

import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/pages/project_details/comments.dart';
import 'package:devspectrum/pages/project_details/post_details.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
import 'package:devspectrum/utils/snackbar.dart';
import 'package:devspectrum/widgets/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

bool isLikeAnimating = false;
bool isLoading=false;

class _PostCardState extends State<PostCard> {
   @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.snap['profImg']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 7,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ['Delete']
                                      .map((e) => InkWell(
                                            onTap: ()async {
                                              if(user.username==widget.snap['username']){
                                                setState(() {
                                                  isLoading=true;
                                                });
                                            String res =  await  FirestoreMethods().deletePost(widget.snap['postId']);
                                            if(res=='success'){
                                              setState(() {
                                                  isLoading=false;
                                                });
                                              Navigator.pop(context);
                                              showSnackbar('Post deleted', context);
                                            } else{
                                               setState(() {
                                                  isLoading=false;
                                                });
                                              Navigator.pop(context);
                                              showSnackbar(res, context);
                                            }
                                              } else{
                                                 setState(() {
                                                  isLoading=false;
                                                });
                                                showSnackbar('You cannot delete someone else\'s post', context);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.34,
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                duration: Duration(milliseconds: 400),
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                    },
                    icon: Icon(
                      widget.snap['likes'].contains(user.uid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 30,
                      color: Colors.red,
                    )),
              ),
              IconButton(
                  onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsPage(snap:widget.snap),
                              ),
                            );
                  },
                  icon: const Icon(
                    Icons.comment,
                    size: 30,
                    color: Colors.yellow,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetails(
                                  projectName: widget.snap['projectName'],
                                    caption: widget.snap['caption'],
                                    github: widget.snap['github'],
                                    postId: widget.snap['postId'],
                                    postUrl: widget.snap['postUrl'],
                                    profImage: widget.snap['profImg'],
                                    username: widget.snap['username'],
                                    datePublished:
                                        widget.snap['datePublished'],
                                        screenshots: widget.snap['screenshots'],
                                        likes: widget.snap['likes']),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notes_outlined,
                            size: 30,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd()
                    .format(widget.snap['datePublished'].toDate()),

//                     
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${widget.snap['likes'].length} ',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'likes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          widget.snap['caption'] == ''
              ? const SizedBox()
              :
              // ignore: prefer_interpolation_to_compose_strings
              Text(
                  "${widget.snap['username']} : " + widget.snap['caption'],
                ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            child: const Text(
              "View comments",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
