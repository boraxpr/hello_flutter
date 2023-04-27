import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'change_notifier.dart';

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
