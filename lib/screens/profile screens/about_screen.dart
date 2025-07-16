import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'App still in progress',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
