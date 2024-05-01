import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetails extends StatefulWidget {
  final Map news;
  const NewsDetails({super.key, required this.news});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  bool isLoading = true;
  int progress = 0;

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progressInt) {
            progress = progressInt;
            if (progress > 90) {
              isLoading = false;
            } else {
              isLoading = true;
            }
            print("WebView is Loading: Progress($progress%)");
            setState(() {});
          },
          onPageStarted: (String url) {
            print("Page is Starting: ($url)");
          },
          onPageFinished: (String url) {
            print("Page has Finished: ($url)");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.news["url"]));

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.news["title"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
              padding: const EdgeInsets.only(bottom: 1),
              height: size.height * 0.8,
              child: WebViewWidget(
                controller: controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}
