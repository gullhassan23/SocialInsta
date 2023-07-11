import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:sociome/Screens/SignupScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sociome/Screens/loginScreen.dart';
import 'package:sociome/Widgets/MobileScreenLayout.dart';
import 'package:sociome/Widgets/WebScreenLayout.dart';
import 'package:sociome/provider/userProvider.dart';

import 'Widgets/Responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB7yvxAFjXNLOtaOMfYdMYSWIJbbZ0UGOQ",
            appId: "1:30195809754:web:99fd630da7f4aa7276d4e3",
            messagingSenderId: "30195809754",
            storageBucket: "sociome-72086.appspot.com",
            projectId: "sociome-72086"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=> UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SocioMe",
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
    
        // home: LoginScreen(),
        // home: SignupScreen(),
    
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              return LoginScreen();
            }),
      ),
    );
  }
}
