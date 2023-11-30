import 'package:flutter/material.dart';

class SearchPage1_3 extends StatelessWidget {
  final Map<String, String> result;

  SearchPage1_3({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result['name'] ?? ''),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            result['image'] ?? 'assets/default_image.jpg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['name'] ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Address: ${result['address'] ?? ''}"),
                Text("Business Hours: ${result['businessHours'] ?? ''}"),
                Text("Rating: ${result['rating'] ?? ''}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}