import 'package:flutter/material.dart';
/**
 * This page is displayed when no result is found for the location.
 */
class NoResultFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Result Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Sorry, no result found.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
