import 'package:flutter/material.dart';

class default_theme {
  default_theme._();

  static const Color orangeAppBar = Color(0xFFDC6815);
  static const Color orange = Colors.orange; //Color(0xFFFF7817);
  static const Color orangeButton = Color(0xFFDA5C00);
  static const Color orangeHomeBar = Color(0xFFC35300);
  static const Color greyDescription = Color(0xFF464646);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);



  static TextStyle header = TextStyle(
    color: Colors.black87.withOpacity(0.6),
    fontWeight: FontWeight.bold,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    color: black,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle titleTextButton = TextStyle(
    fontSize: 14,
    color: orange,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );



 ////////////////////////// Container BoxDecoration used in home screen  /////////////////////
  static BoxDecoration default_decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 5,
        blurRadius: 8,
        offset: const Offset(0, 1),
      ),
    ],
  );

}
