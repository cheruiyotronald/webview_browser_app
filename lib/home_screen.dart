import 'package:flutter/material.dart';
import 'package:webview_browser_app/myweb_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _searchOrNavigate() {
    String query = _searchController.text.trim();
    Uri? uri = Uri.tryParse(query);

    bool isUri = Uri.parse(query).isAbsolute;

    if (isUri) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWebView(url: query),
        ),
      );
    } else {
      String searchUrl = 'https://www.google.com/search?q=$query';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWebView(url: searchUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 50),
            Image.asset("images/browser.png", scale: 2.5),
            SizedBox(height: 50),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Enter URL or search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Icon(Icons.search)),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: _searchOrNavigate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "GO",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
