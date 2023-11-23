import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  static const routeName = '/not-found';
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: const Center(
        child: Text('404'),
      ),
    );
  }
}
