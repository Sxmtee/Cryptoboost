import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoboost/Screens/homeScreen.dart';
import 'package:cryptoboost/Screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        var route = MaterialPageRoute(builder: (context) => LoginScreen());
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
            builder: (BuildContext context) => HomeScreen(user: userDetails));
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
        padding: EdgeInsets.all(30),
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: size.height / 2,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    image: DecorationImage(
                        image: AssetImage("assets/images/crypto.jpg"),
                        fit: BoxFit.cover))),
            Text(
              "CRYPTOBOOST",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.lightBlueAccent),
            ),
            CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
