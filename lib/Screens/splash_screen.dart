// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoboost/Screens/home_screen.dart';
import 'package:cryptoboost/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        var route =
            MaterialPageRoute(builder: (context) => const LoginScreen());
        Navigator.push(context, route);
      } else {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        // print(doc["Username"]);

        var userDetails = {
          "user_id": doc["user_id"],
          "Username": doc["Username"],
          "Email": doc["Email"]
        };
        var route = MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(user: userDetails),
        );
        Navigator.push(context, route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: size.height / 2,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                image: const DecorationImage(
                  image: AssetImage("assets/images/crypto.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              "CRYPTOBOOST",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.lightBlueAccent,
              ),
            ),
            const CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
