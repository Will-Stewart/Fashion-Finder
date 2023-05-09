import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fashionfinder/page/home_page.dart';
import 'package:fashionfinder/page/cart_page.dart';
import 'package:fashionfinder/page/store_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:camera/camera.dart';
import 'package:dcdg/dcdg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: BottomNavBar()));
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 1;

  final Screens = [
    StorePage.defaultUrl(),
    HomePage(),
    CartPage(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 60.0,
        items: const <Widget>[
          Icon(MdiIcons.store,
              size: 40, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(MdiIcons.camera,
              size: 42, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(MdiIcons.cart,
              size: 40, color: Color.fromARGB(255, 255, 255, 255)),
        ],
        color: const Color.fromARGB(255, 41, 41, 41),
        buttonBackgroundColor: const Color.fromARGB(255, 41, 41, 41),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInCubic,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Screens[_page],
    );
  }
}
