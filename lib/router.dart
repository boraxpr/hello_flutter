import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/take_picture.dart';
import 'package:my_first_flutter_app/word_generator.dart';

import 'bloc_test.dart';
import 'favorites_page.dart';
import 'id_card.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Private class to manage the state of the home page
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = TakePictureScreen(
          camera: widget.camera,
        );
        break;
      case 3:
        page = IDCardPage();
        break;
      case 4:
        page = blocPage();
        break;
      default:
        throw UnimplementedError(
          'no widget for $selectedIndex',
        );
    }
    return LayoutBuilder(builder: (
      context,
      constraints,
    ) {
      return Scaffold(
        body: Center(
          child: page,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_rounded),
              label: 'IDCard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Bloc test',
            )
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            setState(() => selectedIndex = index);
          },
        ),
      );
    });
  }
}
