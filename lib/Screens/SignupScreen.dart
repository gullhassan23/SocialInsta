import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sociome/Screens/loginScreen.dart';
import 'package:sociome/Widgets/TextForm.dart';
import 'package:sociome/Widgets/utils.dart';

import 'package:sociome/resources/AuthMethod.dart';

import '../Widgets/MobileScreenLayout.dart';
import '../Widgets/Responsive.dart';
import '../Widgets/WebScreenLayout.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _userController = TextEditingController();

  Uint8List? _image;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userController.dispose();
    _bioController.dispose();
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthMethods().SignUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      isLoading = false;
    });

    // print(res);
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      //
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              )));
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
    // image = await picker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   //update Ui

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Image.asset(
              "assets/images/Sciome.png",
              color: Colors.white,
              height: 64,
            ),
            const SizedBox(
              height: 64,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png"),
                      ),
                Positioned(
                    bottom: -10,
                    left: 70,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            TextForm(
                hintText: "Enter your username",
                textInputType: TextInputType.text,
                textEditingController: _userController),
            const SizedBox(
              height: 22,
            ),
            TextForm(
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController),
            const SizedBox(
              height: 22,
            ),
            TextForm(
              hintText: "Enter your password",
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(
              height: 22,
            ),
            TextForm(
                hintText: "Tell us about Yourself?",
                textInputType: TextInputType.text,
                textEditingController: _bioController),
            const SizedBox(
              height: 22,
            ),
            InkWell(
              onTap: signupUser,
              child: Container(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text("Sign up"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Do you  have an account?"),
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    child: Text(
                      "Log in",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
