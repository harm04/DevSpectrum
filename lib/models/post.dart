import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String github;
  final String username;
  final String postId;
  final datePublished;
  final String uid;
  final String profImg;
  final String postUrl;
  final likes;
  final screenshots;

  const Post({
    required this.caption,
    required this.github,
    required this.postId,
    required this.datePublished,
    required this.username,
    required this.uid,
    required this.profImg,
    required this.postUrl,
    required this.likes,
    required this.screenshots
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'github': github,
        'caption': caption,
        'postId': postId,
        'datePublished': datePublished,
        'uid': uid,
        'profImg': profImg,
        'postUrl': postUrl,
        'likes': likes,
        'screenshots':screenshots
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      caption: snapshot['caption'],
       github: snapshot['github'],
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      profImg: snapshot['profImg'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
      screenshots: snapshot['screenshots']
    );
  }
}
