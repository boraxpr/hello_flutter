//ID Card Page
import 'package:flutter/material.dart';

class IDCardPage extends StatefulWidget {
  const IDCardPage({super.key});
  @override
  State<IDCardPage> createState() => _IDCardPageState();
}

class _IDCardPageState extends State<IDCardPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: IDCard());
  }
}

class IDCard extends StatelessWidget {
  const IDCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Card'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: theme.colorScheme.secondary,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Text(
                  'ID Card',
                  style: style,
                  semanticsLabel: 'ID Card',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IDCardPage()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
