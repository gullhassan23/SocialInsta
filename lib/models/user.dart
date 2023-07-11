import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String password;
  String username;
  String bio;
  String uid;
  String photoUrl;
  List followers;
  List following;
  User({
    required this.email,
    required this.password,
    required this.username,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers": followers,
        "password": password,
        "following": following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        email: snapshot['email'],
        password: snapshot['password'],
        username: snapshot['username'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photoUrl'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
