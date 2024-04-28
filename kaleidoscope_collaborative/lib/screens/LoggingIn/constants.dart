import 'package:flutter/material.dart';

//Whenever you search for a variable next time you start searching with a k and android studio will suggest a list of all the variable constants that start with a k

final kButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF6750A4),
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(100),
  ),
);

final kSmallButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF6750A4),
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(100),
  ),
);

final kAccommodationButtonStyle = OutlinedButton.styleFrom(
  // primary: Color(,
  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  // shape: RoundedRectangleBorder(
  //   borderRadius: BorderRadius.circular(100),
  foregroundColor: Colors.black, side: const BorderSide(
              color: Colors.black,
            ),
);


const kButtonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);