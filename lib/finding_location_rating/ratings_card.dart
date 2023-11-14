import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class RatingPage extends StatefulWidget
 
{
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating Cards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Image.asset('images/logo.jpg', height: 125, width: 125),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar(),
                    SizedBox(height: 5),
                    // Left align the text 
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Joe Smith', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Pad the text to the right 
            const Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I’ve been going for a few weeks and my son loves it. He gets to try new things in a safe environment. It also allows him to spend some time wit...',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: 8), // Add spacing between the two text lines
                  Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),        
          ],
      ),
      ),
    );
  }
}

class RatingBar extends StatefulWidget
 
{
  const RatingBar({super.key});

  @override
  _RatingBarState createState() => _RatingBarState();
}

// Rating bar: 
class _RatingBarState extends State<RatingBar> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Container(
            width: 45, // Adjust the width to control the size of the circle
            height: 45, // Adjust the height to control the size of the circle
            margin: const EdgeInsets.symmetric(horizontal: 6), // Adjust the spacing between stars
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(47, 10, 158, 0.612) // Background color of the circle
            ),
            child: IconButton(
              icon: Icon(Icons.star, size: 30, color: rating >= i ? Colors.yellow : Colors.white),
              onPressed: () {
                setState(() {
                  rating = i;
                });
              },
            )
          ),
      ],
    );
  }
}


// Feature boxes 

class FeatureBoxes extends StatefulWidget
 
{
  const FeatureBoxes({super.key});

  @override
  _FeatureBoxesState createState() => _FeatureBoxesState();
}

// Rating bar: 
class _FeatureBoxesState extends State<FeatureBoxes> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 1; i <= 5; i++)
          Container(
            width: 45, // Adjust the width to control the size of the circle
            height: 45, // Adjust the height to control the size of the circle
            margin: const EdgeInsets.symmetric(horizontal: 6), // Adjust the spacing between stars
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(47, 10, 158, 0.612) // Background color of the circle
            ),
            child: IconButton(
              icon: Icon(Icons.star, size: 30, color: rating >= i ? Colors.yellow : Colors.white),
              onPressed: () {
                setState(() {
                  rating = i;
                });
              },
            )
          ),
      ],
    );
  }
}