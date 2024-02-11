import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/link.dart';

class PostDetails extends StatefulWidget {
  final String caption;
  final String username;
  final String postUrl;
  final String github;
  final String profImage;
  final likes;
  final screenshots;
  final String postId;
  final datePublished;
  const PostDetails(
      {super.key,
      required this.caption,
      required this.username,
      required this.postUrl,
      required this.github,
      required this.profImage,
      required this.postId,
      this.datePublished,
      required this.likes,
      required this.screenshots});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.username),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Post')
              .doc(widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('some internal error occured'),
                );
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text('Project name',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 20,
                ),
              
                Card(
                  elevation: 20,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.network(
                      widget.postUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                
                  Row(
                    children: [
                      Column(
                        children: [
                          Link(
                            uri: Uri.parse(widget.github),
                            builder: (context, followLink) {
                              return InkWell(
                                onTap: followLink,
                                child: const Icon(
                                  FontAwesomeIcons.github,
                                  size: 30,
                                ),
                              );
                            }),
                            SizedBox(height: 5,),
                    const Text('Github '),
                   
                    
                        ],
                      ),
                       SizedBox(width: 10,),
                      Column(
                        children: [
                          Icon(Icons.favorite,size: 35,color: Colors.red,),
                           Text('${widget.likes.length.toString()} likes '),
                        ],
                      )
                    ],
                  ),
                   SizedBox(height: 20,),
                const Text('Screenshots',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 20,
                ),
                widget.screenshots == []
                    ? const SizedBox()
                    : Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 5),
                            itemCount: widget.screenshots.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Image.network(
                                  widget.screenshots[index].toString(),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                      ),
              ],
            );
          },
        ));
  }
}
