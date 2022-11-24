import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mob_auth/pages/home_screen.dart';
import 'package:mob_auth/pages/login_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mobile Auth",
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: (FirebaseAuth.instance.currentUser != null)? const HomeScreen():const LoginScreen(),
    );
  }
}
