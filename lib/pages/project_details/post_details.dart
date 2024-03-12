import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/link.dart';

class PostDetails extends StatefulWidget {
  final String caption;
  final String projectName;
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
      required this.projectName,
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
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       widget.projectName!=''?  Text(
                          widget.projectName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ):const Text(
                         'Project',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
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
                                      size: 20,
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text('Github ',style: TextStyle(fontSize: 13),),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 25,
                              color: Colors.red,
                            ),
                            Text('${widget.likes.length.toString()} likes ',style: const TextStyle(fontSize: 13),),
                          ],
                        )
                      ],
                    ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.caption),
                          SizedBox(height: 20,),
                          Card(
                            elevation: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.33,
                              child: Image.network(
                                widget.postUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  
                    const Text(
                      'Screenshots',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    widget.screenshots == []
                        ? const SizedBox()
                        : Flexible(
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 3,
                                        childAspectRatio: 0.56,
                                        mainAxisSpacing: 5),
                                itemCount: widget.screenshots.length,
                                scrollDirection: Axis.vertical,
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
                ),
              ),
            );
          },
        ));
  }
}
