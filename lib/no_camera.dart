import 'package:flutter/material.dart';

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
