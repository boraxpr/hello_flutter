import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:camera/camera.dart';

import 'change_notifier.dart';
import 'no_camera.dart';
import 'router.dart';

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
    runApp(
      MyApp(
        camera: firstCamera,
      ),
    );
  } else {
    runApp(NoCamera());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyAppState>(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My First Flutter App',
        theme: ThemeData(
          fontFamily: 'Raleway',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(
          camera: widget.camera,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
