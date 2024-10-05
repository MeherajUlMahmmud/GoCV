import 'package:flutter/material.dart';
import 'package:gocv/utils/constants.dart';

class NotFoundScreen extends StatelessWidget {
  static const routeName = Constants.notFoundScreenRouteName;

  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Not Found',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10.0),
            child: Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: const SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Page not found',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
