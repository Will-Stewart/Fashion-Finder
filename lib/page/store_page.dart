import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        extendBodyBehindAppBar: false,
        appBar: DarkBar(),
        body: WebView(
          initialUrl: 'https://modassilviabenitez.myshopify.com/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      );
}

//Appbar Class
class DarkBar extends StatelessWidget implements PreferredSizeWidget {
  const DarkBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Call the `goBack` method on the WebView to go back to the previous page
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Call the `goForward` method on the WebView to go forward to the next page
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
