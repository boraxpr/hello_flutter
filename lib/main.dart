import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setAlwaysOnTop(true);
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
          fontFamily: 'Raleway',
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
  var favorites = <WordPair>[];

  // get next word pair then notify listeners (a method from ChangeNotifier)
  // to ensure that any widgets that are listening to this object will rebuild.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//Stateful widget to manage the state of the home page
//Stateful widgets maintain state that might change during the lifetime of the widget.
class MyHomePage extends StatefulWidget {
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
        page = Placeholder();
        SystemNavigator.pop();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Exit'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(wordPair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.wordPair,
  });

  final WordPair wordPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 70,
    );
    return Card(
      color: theme.colorScheme.secondary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Text(
          wordPair.asLowerCase,
          style: style,
          semanticsLabel: "${wordPair.first} ${wordPair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        var pair = appState.favorites[index];
        return ListTile(
          title: Text(pair.asLowerCase),
          onTap: () {
            Clipboard.setData(ClipboardData(text: pair.asLowerCase));
          },
        );
      },
    );
  }
}
