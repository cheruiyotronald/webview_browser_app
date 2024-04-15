import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;

  const MyWebView({super.key, required this.url});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
    controller
      ..setNavigationDelegate(
        NavigationDelegate(onPageStarted: (url) {
          setState(
            () {
              loadingPercentage = 0;
            },
          );
        }, onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        }, onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        }),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("SnackBar", onMessageReceived: (message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message.message),
        ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoBack()) {
                    await controller.goBack();
                  } else {
                    messenger.showSnackBar(
                        SnackBar(content: Text("No Back History Found")));
                  }
                  return;
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoForward()) {
                    await controller.goForward();
                  } else {
                    messenger.showSnackBar(
                        SnackBar(content: Text("No Forward History Found")));
                  }
                  return;
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
              IconButton(
                onPressed: () {
                  controller.reload();
                },
                icon: Icon(Icons.replay),
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            )
        ],
      ),
    );
  }
}
