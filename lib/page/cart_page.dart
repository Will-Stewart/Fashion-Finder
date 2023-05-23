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
          fontWeight: FontWeight.w600,
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

List<String> titles = [
  "Bolsa de Mujer",
  "Chamarra Blanca Con Gorro",
  "Pans de Ejercicio Azul Marino",
  "Blusa Cuadros Rosa",
  "Vestido Gris Con Rayas Horizontales",
  "Bolsa De Mano"
];

List<String> subtitles = [
  "TOMMY HILFIGER",
  "TOMMY HILFIGER",
  "TOMMY HILFIGER",
  "TOMMY HILFIGER",
  "TOMMY HILFIGER",
  "VICTORIA'S SECRET"
];

List<String> images = [
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_79fb226d-e0ce-401d-98a0-7052e74b8cc7.jpg?v=1656896203",
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_a656a8e6-e828-4460-abcf-c5ac0463cb94.jpg?v=1656895056",
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_ba068bbd-5e35-40e4-a272-c5f7ebfa4d9f.jpg?v=1656894572",
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_61b1388a-738a-4151-a839-981f564b05f0.jpg?v=1656885643",
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_69056b42-56da-41d6-b45d-261af2999f9b.jpg?v=1656821523",
  "https://cdn.shopify.com/s/files/1/0642/6103/0111/products/image_0c88fd04-7991-40bf-8480-bd2bc74a2e72.jpg?v=1656965773"
];

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
          fontWeight: FontWeight.w600,
        )),
      ),
    ),
    Container(
      height: 390.0,
      width: 355.0,
      child: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Container(
            height: 80.0,
            margin: const EdgeInsets.all(10.0),
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
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                width: 75.0,
                height: 75.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                titles[index],
                style: GoogleFonts.libreBaskerville(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              subtitle: Text(
                subtitles[index],
                style: GoogleFonts.libreBaskerville(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 196, 196, 196),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
  ],
);
