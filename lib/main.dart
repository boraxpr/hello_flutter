import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //Run MyApp
  runApp(MyApp());
}

/* GitHub Copilot teacher:
-- Widgets are the building blocks of a Flutter app.
-- In Flutter, almost everything is a widget, including alignment, padding, and layout.
-- Widgets are immutable, meaning that their properties can’t change—all values are final.
-- Widgets are used to build everything in Flutter, from the smallest icon to the largest screen.
-- Widgets are the basic building blocks of a Flutter app’s user interface and they form a hierarchy based on composition.
-- This hierarchy is called the widget tree.
-- Each widget nests inside its parent and receives context from the parent.
-- Widgets can be stateful or stateless.
-- A stateless widget is drawn to the screen and is never redrawn.
-- A stateful widget can change dynamically, for example by animating a property in response to user input.
-- When the state of a widget changes, the widget rebuilds its user interface by calling the build method. 
-- The framework then compares the new version of the widget tree to the previous version and determines the minimum changes needed in the underlying render tree to ensure that the user interface reflects the changes.
-- The framework then updates the render tree, which results in visual changes on the device.
-- The widget tree is a lightweight object that can be easily discarded and regenerated, but the render tree is a heavy object that requires a lot of processing to build and update.
-- The framework optimizes the build process by caching the render tree. When the widget tree is rebuilt, the framework compares the new version of the widget tree to the previous version and determines what has changed.
-- The framework then updates the render tree accordingly, without having to go through the heavy process of calculating the changes.
-- Then, when the user interacts with the app, the framework handles the interaction by scheduling a new frame for the UI, which causes the framework to rebuild the widget tree in the zone where the interaction occurred.
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // get next word pair then notify listeners (a method from ChangeNotifier)
  // to ensure that any widgets that are listening to this object will rebuild.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // 1. The build method is called whenever the widget needs to be rebuilt.
  @override
  Widget build(BuildContext context) {
    // 2. The context parameter is used to access information about the location of a widget in the widget tree.
    var appState = context.watch<MyAppState>();
    // 3. The context.watch method is used to listen to changes in the MyAppState object.
    // 4. Every build method must return a widget. In this case, It returns Scaffold, which is a layout for the major Material Components.
    return Scaffold(
      // 5. Column is a layout widget that displays its children in a vertical array.
      body: Column(
        children: [
          // 6. The Text widget displays a string of text with single style.
          Text('A random AWESOME idea:'),
          // 7. App state is a variable that contains the current word pair.
          // 8. The asLowerCase method converts the word pair to lowercase.
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ], // trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
