import 'dart:convert';

import 'package:cryptoboost/Screens/loginScreen.dart';
import 'package:cryptoboost/Utils/snackBar.dart';
import 'package:cryptoboost/Widgets/singlePost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  Map user;
  HomeScreen({super.key, required this.user});

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
        "https://eventregistry.org/api/v1/article/getArticles?resultType=articles&keyword=Bitcoin&keyword=Ethereum&keyword=Litecoin&keywordOper=or&lang=eng&articlesSortBy=date&includeArticleConcepts=true&includeArticleCategories=true&articleBodyLen=300&articlesCount=10&apiKey=45579897-104d-4d14-987a-ea9427fb31c4");
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
        return await false;
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
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: FutureBuilder(
          future: fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("NO DATA"),
              );
            }
            if (snapshot.hasError) {
              return Center(
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
      title: Text("Log Out"),
      content: Text("Are you Sure you want to logout"),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
          color: Colors.lightBlueAccent,
        ),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            var route = MaterialPageRoute(builder: (context) => LoginScreen());
            Navigator.push(context, route);
          },
          child: Text("Logout"),
          color: Colors.red,
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
