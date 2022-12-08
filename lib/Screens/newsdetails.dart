import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetails extends StatefulWidget {
  Map news;
  NewsDetails({super.key, required this.news});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  bool isLoading = true;
  int progress = 0;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.news["title"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Visibility(
                visible: isLoading,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blueAccent,
                  minHeight: 3,
                  value: progress / 100,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 1),
              height: size.height * 0.8,
              child: WebView(
                initialUrl: widget.news["url"],
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController controller) {
                  _completer.complete(controller);
                },
                onProgress: (int progressInt) {
                  progress = progressInt;
                  if (progress > 90) {
                    isLoading = false;
                  } else {
                    isLoading = true;
                  }
                  print("WebView is Loading: Progress($progress%)");
                  setState(() {});
                },
                navigationDelegate: (NavigationRequest navigation) {
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print("Page is Starting: ($url)");
                },
                onPageFinished: (String url) {
                  print("Page has Finished: ($url)");
                },
                gestureNavigationEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
