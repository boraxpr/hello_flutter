import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'change_notifier.dart';

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
