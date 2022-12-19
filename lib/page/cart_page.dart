import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DarkBar(),
        body: ListView(children: <Widget>[
          recentScanned,
          savedCart,
        ]),
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      )),
      title: Text(
        'Cart Page',
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

// Widgets
Widget recentScanned = Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        'Recently Scanned',
        style: GoogleFonts.libreBaskerville(
            textStyle: const TextStyle(
          color: Color.fromARGB(255, 41, 41, 41),
          fontSize: 20,
        )),
      ),
    ),
    Container(
      height: 150.0,
      width: 355.0,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 29, 29, 29),
              Color.fromARGB(255, 138, 138, 138),
            ],
          )),
      child: const Center(
        child: Text(
          "Carosel Of Recent Scans Here",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    )
  ],
);

Widget savedCart = Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        'Saved In Cart',
        style: GoogleFonts.libreBaskerville(
            textStyle: const TextStyle(
          color: Color.fromARGB(255, 41, 41, 41),
          fontSize: 20,
        )),
      ),
    ),
    Container(
      height: 390.0,
      width: 355.0,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 29, 29, 29),
              Color.fromARGB(255, 138, 138, 138),
            ],
          )),
      child: const Center(
        child: Text(
          "List of Saved Items Here",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    )
  ],
);
