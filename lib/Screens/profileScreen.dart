import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sociome/Widgets/FollowButton.dart';
import 'package:sociome/Widgets/utils.dart';
import 'package:sociome/resources/FirestoreMethod.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      followers = userSnap.data()!["followers"].length;
      following = userSnap.data()!["following"].length;
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

      userdata = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(userdata["username"]),
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userdata["photoUrl"]),
                          radius: 50,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStartColumn(postLen, "Posts"),
                                  buildStartColumn(followers, "Followers"),
                                  buildStartColumn(following, "Following")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? FollowButton(
                                          text: "Edit Profile",
                                          backgroundColor: Colors.transparent,
                                          textColor: Colors.white,
                                          borderColor: Colors.white,
                                          function: () {},
                                        )
                                      : isFollowing
                                          ? FollowButton(
                                              text: "Unfollow",
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userdata["uid"],
                                                );
                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              text: "Follow",
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              borderColor: Colors.blue,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userdata["uid"],
                                                );
                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                            )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          userdata["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          userdata["bio"],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 3,
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid", isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(
                                (snap.data()! as dynamic)["postUrl"]),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  })
            ]),
          );
  }

  Column buildStartColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label.toString(),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
