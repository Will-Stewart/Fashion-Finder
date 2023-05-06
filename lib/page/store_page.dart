import 'package:flutter/material.dart'
    show
        AppBar,
        BorderRadius,
        BuildContext,
        Color,
        Icon,
        IconButton,
        Icons,
        Key,
        Radius,
        RoundedRectangleBorder,
        Scaffold,
        Size,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget,
        kToolbarHeight;
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StorePage extends StatefulWidget {
  final String url;

  // Default constructor with required parameter
  StorePage({Key? key, required this.url}) : super(key: key);

  // Additional constructor with default URL value
  StorePage.defaultUrl({Key? key})
      : url = 'https://modassilviabenitez.myshopify.com/',
        super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return WebViewApp(url: widget.url);
  }
}

class WebViewApp extends StatefulWidget {
  final String url;
  WebViewApp({Key? key, required this.url}) : super(key: key);
  late WebViewController controller;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Call the `goBack` method on the WebView to go back to the previous page
            widget.controller.goBack();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              widget.controller.goForward();
              // Call the `goForward` method on the WebView to go back to the previous page
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
        title: Text(
          'Store Page',
          style: GoogleFonts.libreBaskerville(
              textStyle:
                  const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        shadowColor: const Color.fromARGB(255, 41, 41, 41),
        elevation: 0,
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          widget.controller = webViewController;
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
