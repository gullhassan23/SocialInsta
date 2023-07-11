import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String description;
  String postId;
  String username;
  final datePublished;
  String uid;
  String postUrl;
  String profImage;
  final likes;

  Post({
    required this.description,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.uid,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "postId": postId,
        "username": username,
        "uid": uid,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "likes": likes,
        "profImage": profImage,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      likes: snapshot["likes"],
      datePublished: snapshot['datePublished'],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'],
      postId: snapshot["postId"],
      username: snapshot['username'],
      profImage: snapshot['profImage'],
      uid: snapshot['uid'],
    );
  }
}
