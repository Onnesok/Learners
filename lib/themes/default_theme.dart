import 'package:flutter/material.dart';

class default_theme {
  default_theme._();

  static const Color orange = Colors.orange; //Color(0xFFFF7817);
  static const Color green = Colors.green;
  static const Color orangeButton = Color(0xFFDA5C00);
  static const Color orangeHomeBar = Color(0xFFC35300);
  static const Color greyDescription = Color(0xFF464646);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);



  // header is used in screens like search screen result text where big text is required or u say header is required
  static TextStyle header = TextStyle(
    color: Colors.black87.withOpacity(0.6),
    fontWeight: FontWeight.bold,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  ////// Header green for course enroll page
  static TextStyle header_green = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    letterSpacing: 1,
    fontFamily: "anton",
    overflow: TextOverflow.ellipsis,
  );

  // header_grey is not available screens texts... "no course available"
  static TextStyle header_grey = TextStyle(
    color: Colors.grey.withOpacity(0.8),
    fontWeight: FontWeight.bold,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  // title is used in homecontents category text and others
  static const TextStyle title = TextStyle(
    fontSize: 16,
    color: black,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  /// title green for course enrollment page
  static const TextStyle title_green = TextStyle(
    fontSize: 16,
    color: Colors.green,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );


  //// appbar_orange is the textstyle for orange background appbar
  static const TextStyle appbar_orange = TextStyle(
    fontSize: 22,
    color: black,
    letterSpacing: 2,
    fontFamily: "shadow",
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  /// titleTextButton is used in textbutton "see more" in homecontents
  static const TextStyle titleTextButton = TextStyle(
    fontSize: 14,
    color: orange,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );


  static TextStyle body_grey = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 16,
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
