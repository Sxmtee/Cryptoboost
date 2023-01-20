import 'package:cryptoboost/Screens/newsdetails.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  Map post;
  SinglePost({super.key, required this.post});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  String returnTitle(String title) {
    if (title.length > 20) {
      return "${title.substring(0, 35)}...";
    } else {
      return title;
    }
  }

  String returnsubTitle(String subTitle) {
    if (subTitle.length > 20) {
      return "${subTitle.substring(0, 35)}...";
    } else {
      return subTitle;
    }
  }

  String returnUrl(String url) {
    if (url.length > 20) {
      return "${url.substring(0, 30)}...";
    } else {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        var route = MaterialPageRoute(
            builder: (context) => NewsDetails(news: widget.post));
        Navigator.push(context, route);
      },
      child: Card(
        elevation: 10,
        child: SizedBox(
          height: 300,
          width: size.width,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Text(
                  returnTitle(widget.post["title"]),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Image.network(
                widget.post["image"],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Text(returnsubTitle(widget.post["title"])),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Row(
                  children: [
                    const Icon(Icons.link),
                    Expanded(
                      child: Text(returnUrl(widget.post["url"])),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
