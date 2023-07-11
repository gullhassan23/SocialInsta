import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociome/Screens/SearchScreen.dart';
import 'package:sociome/Screens/addPost.dart';
import 'package:sociome/Screens/feedScreen.dart';
import 'package:sociome/Screens/profileScreen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPost(),
  Text("notify"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
