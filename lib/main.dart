import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
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
    runApp(MyApp(camera: firstCamera));
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
        home: Auth(
          camera: widget.camera,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Auth extends StatefulWidget {
  Auth({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly:
              true, // Set to true to use only biometrics (Face ID/Touch ID),
        ),
      );
    } catch (e) {
      print('Error during authentication: $e');
    }

    if (authenticated) {
      print('User authenticated successfully');
      // Use the captured context variable
    } else {
      print('Authentication failed');
    }
    return authenticated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Flutter'),
      ),
      body: Center(
        child: IconButton(
          onPressed: () async {
            bool isAuthenticated = await _authenticate();
            if (isAuthenticated) {
              if (context.mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp(camera: widget.camera)));
              }
            }
          },
          icon: FutureBuilder<bool>(
            future: _authenticate(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Icon(
                  snapshot.data == true ? Icons.lock_open : Icons.lock,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
