// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:devspectrum/models/user.dart'as models;
// import 'package:devspectrum/providers/user_provider.dart';
// import 'package:devspectrum/utils/snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PostCard extends StatefulWidget {
//   final snap;
//   const PostCard({
//     Key? key,
//     required this.snap,
//   }) : super(key: key);

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   int commentLen = 0;
//   bool isLikeAnimating = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCommentLen();
//   }

//   fetchCommentLen() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       commentLen = snap.docs.length;
//     } catch (err) {
//       showSnackbar(err.toString(), context);
//     }
//     setState(() {});
//   }

//   // deletePost(String postId) async {
//   //   try {
//   //     await FireStoreMethods().deletePost(postId);
//   //   } catch (err) {
//   //     showSnackBar(
//   //       context,
//   //       err.toString(),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final models.User user = Provider.of<UserProvider>(context).getUser;
//     final width = MediaQuery.of(context).size.width;

//     return Container(
//       // boundary needed for web
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black
//         ),

//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Column(
//         children: [
//           // HEADER SECTION OF THE POST
//           Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 4,
//               horizontal: 16,
//             ).copyWith(right: 0),
//             child: Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: NetworkImage(
//                     widget.snap['profImage'].toString(),
//                   ),
//                 ),
// Expanded(
//   child: Padding(
//     padding: const EdgeInsets.only(
//       left: 8,
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           widget.snap['username'].toString(),
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
//                 widget.snap['uid'].toString() == user.uid
//                     ? IconButton(
//                         onPressed: () {
//                           showDialog(
//                             useRootNavigator: false,
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 child: ListView(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     shrinkWrap: true,
//                                     children: [
//                                       'Delete',
//                                     ]
//                                         .map(
//                                           (e) => InkWell(
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 12,
//                                                         horizontal: 16),
//                                                 child: Text(e),
//                                               ),
//                                               onTap: () {
//                                                 // deletePost(
//                                                 //   widget.snap['postId']
//                                                 //       .toString(),
//                                                 // );
//                                                 // remove the dialog box
//                                                 Navigator.of(context).pop();
//                                               }),
//                                         )
//                                         .toList()),
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.more_vert),
//                       )
//                     : Container(),
//               ],
//             ),
//           ),
//           // IMAGE SECTION OF THE POST
//           GestureDetector(
//             onDoubleTap: () {
//               // FireStoreMethods().likePost(
//               //   widget.snap['postId'].toString(),
//               //   user.uid,
//               //   widget.snap['likes'],
//               // );
//               setState(() {
//                 isLikeAnimating = true;
//               });
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.35,
//                   width: double.infinity,
//                   child: Image.network(
//                     widget.snap['postUrl'].toString(),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 200),
//                   opacity: isLikeAnimating ? 1 : 0,
//                   // child: LikeAnimation(
//                   //   isAnimating: isLikeAnimating,
//                   //   duration: const Duration(
//                   //     milliseconds: 400,
//                   //   ),
//                   //   onEnd: () {
//                   //     setState(() {
//                   //       isLikeAnimating = false;
//                   //     });
//                   //   },
//                   //   child: const Icon(
//                   //     Icons.favorite,
//                   //     color: Colors.white,
//                   //     size: 100,
//                   //   ),
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//           // LIKE, COMMENT SECTION OF THE POST
//           Row(
//             children: <Widget>[
//               // LikeAnimation(
//               //   isAnimating: widget.snap['likes'].contains(user.uid),
//               //   smallLike: true,
//               //   child: IconButton(
//               //     icon: widget.snap['likes'].contains(user.uid)
//               //         ? const Icon(
//               //             Icons.favorite,
//               //             color: Colors.red,
//               //           )
//               //         : const Icon(
//               //             Icons.favorite_border,
//               //           ),
//               //     onPressed: () => FireStoreMethods().likePost(
//               //       widget.snap['postId'].toString(),
//               //       user.uid,
//               //       widget.snap['likes'],
//               //     ),
//               //   ),
//               // ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.comment_outlined,
//                 ),
//                 onPressed: (){},
//                 // onPressed: () => Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (context) => CommentsScreen(
//                 //       postId: widget.snap['postId'].toString(),
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//               IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                   ),
//                   onPressed: () {}),
//               Expanded(
//                   child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: IconButton(
//                     icon: const Icon(Icons.bookmark_border), onPressed: () {}),
//               ))
//             ],
//           ),
//           //DESCRIPTION AND NUMBER OF COMMENTS
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 DefaultTextStyle(
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontWeight: FontWeight.w800),
//                     child: Text(
//                       '${widget.snap['likes'].length} likes',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     )),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: RichText(
//                     text: TextSpan(
//                       style: const TextStyle(color: Colors.white),
//                       children: [
//                         TextSpan(
//                           text: widget.snap['username'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' ${widget.snap['description']}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       'View all $commentLen comments',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   onTap: () {}
//                   //  Navigator.of(context).push(
//                   //   MaterialPageRoute(
//                   //     builder: (context) => CommentsScreen(
//                   //       postId: widget.snap['postId'].toString(),
//                   //     ),
//                   //   ),
//                   // ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     DateFormat.yMMMd()
//                         .format(widget.snap['datePublished'].toDate()),

//                     style: const TextStyle(
//                       color: secondaryColor,
//                     ),
//                      'hi'
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:devspectrum/models/user.dart';
import 'package:devspectrum/pages/project_details/post_details.dart';
import 'package:devspectrum/providers/user_provider.dart';
import 'package:devspectrum/resources/firestore_methods.dart';
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
                                            onTap: () {},
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
            height: MediaQuery.of(context).size.height * 0.4,
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
                  onPressed: () {},
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

//                     'hi'
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
