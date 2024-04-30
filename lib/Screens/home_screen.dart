// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cryptoboost/Screens/login_screen.dart';
import 'package:cryptoboost/Utils/snack_bar.dart';
import 'package:cryptoboost/Widgets/single_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final Map user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 0;
  goBack() {
    if (count >= 2) {
      SystemNavigator.pop();
    } else {
      count++;
    }
  }

  fetchNews() async {
    var uri = Uri.parse(
      "https://eventregistry.org/api/v1/article/getArticles?resultType=articles&keyword=Bitcoin&keyword=Ethereum&keyword=Litecoin&keywordOper=or&lang=eng&articlesSortBy=date&includeArticleConcepts=true&includeArticleCategories=true&articleBodyLen=300&articlesCount=10&apiKey=45579897-104d-4d14-987a-ea9427fb31c4",
    );
    var request = await http.get(uri);
    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);
      var articles = response["articles"];
      var results = articles["results"];
      return results;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack();
        showSnackBar(context, "Double Tap to Exit");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.user["Username"] + "'s Profile"),
          actions: [
            IconButton(
              onPressed: (() {
                showAlert(context);
              }),
              icon: const Icon(Icons.logout_outlined),
            )
          ],
        ),
        body: FutureBuilder(
          future: fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("NO DATA"),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("ERROR OCCURED"),
              );
            }

            List posts = snapshot.data as List;
            return ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SinglePost(post: posts[index]);
              },
            );
          },
        ),
      ),
    );
  }

  showAlert(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Log Out"),
      content: const Text("Are you Sure you want to logout"),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.lightBlueAccent,
          child: const Text("Cancel"),
        ),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            var route = MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
            Navigator.push(context, route);
          },
          color: Colors.red,
          child: const Text("Logout"),
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
