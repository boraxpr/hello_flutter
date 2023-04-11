import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //Run MyApp
  runApp(MyApp());
}

/*
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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              print('Button pressed');
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
