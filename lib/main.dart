import 'dart:convert';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';

Future<void> main() async {
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    windowManager.setAlwaysOnTop(true);
  }

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  if (cameras.isNotEmpty) {
    final firstCamera = cameras.first;
    //Run MyApp
    runApp(MyApp(camera: firstCamera));
  } else {
    runApp(NoCamera());
  }
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
  const MyApp({super.key, required this.camera});
  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My First Flutter App',
        theme: ThemeData(
          fontFamily: 'Raleway',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(camera: camera),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var files = <File>[];
  var base64Image = '';

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

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void addFile(File file) {
    files.add(file);
    notifyListeners();
  }

  void removeFile(File file) {
    files.remove(file);
    notifyListeners();
  }
}

class NoCamera extends StatefulWidget {
  const NoCamera({super.key});
  @override
  State<NoCamera> createState() => _NoCameraState();
}

class _NoCameraState extends State<NoCamera> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineLarge;
    return MaterialApp(
      title: 'My First Flutter App',
      theme: ThemeData(
        fontFamily: 'Raleway',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: Scaffold(
        body: Center(
          child: Text(
            'No Camera',
            style: style,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Stateful widget to manage the state of the home page
//Stateful widgets maintain state that might change during the lifetime of the widget.
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
        page = Base64ToImagePage();
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
              icon: Icon(Icons.code),
              label: 'Base64 to Img',
            ),
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

class Base64ToImagePage extends StatefulWidget {
  const Base64ToImagePage({super.key});

  @override
  State<Base64ToImagePage> createState() => _Base64ToImagePageState();
}

class _Base64ToImagePageState extends State<Base64ToImagePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    ImageProvider image = appState.base64Image.isEmpty
        ? AssetImage("assets/icons/43258373.png")
        : MemoryImage(base64Decode(appState.base64Image)) as ImageProvider;
    return Scaffold(
      body: Center(
        child: Image(
          image: image,
        ),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;
  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller)),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    String base64Image;
    // Image file to base64
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    base64Image = base64Encode(imageBytes);
    // Save base64 to appState
    var appState = context.watch<MyAppState>();
    appState.base64Image = base64Image;
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(imageFile),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

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

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        var pair = appState.favorites[index];
        return Material(
          elevation: 15.0,
          shadowColor: Colors.deepOrange.shade300,
          child: ListTile(
            title: Text(pair.asLowerCase),
            onTap: () {
              //copy to clipboard
              Clipboard.setData(ClipboardData(text: pair.asLowerCase));
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.removeFavorite(pair);
              },
            ),
          ),
        );
      },
    );
  }
}

class FileBrowsePage extends StatefulWidget {
  const FileBrowsePage({super.key});
  @override
  State<FileBrowsePage> createState() => _FileBrowsePageState();
}

//File Browse Page
class _FileBrowsePageState extends State<FileBrowsePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: ListView.builder(
        itemCount: appState.files.length,
        itemBuilder: (context, index) {
          File file = appState.files[index];
          String fileName = file.path.split('/').last;
          return Material(
            elevation: 15.0,
            shadowColor: Colors.deepOrange.shade300,
            child: ListTile(
              leading: Icon(Icons.image),
              title: Text(
                fileName,
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      appState.removeFile(file);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        // Provide an onPressed callback.
        onPressed: () async {
          final file = await FilePicker.platform.pickFiles();
          if (file != null) {
            appState.addFile(
              File(file.files.single.path!),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
