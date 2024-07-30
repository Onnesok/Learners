import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class home_contents extends StatefulWidget {
  const home_contents({super.key});

  @override
  State<home_contents> createState() => _home_contentsState();
}

class _home_contentsState extends State<home_contents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "learners",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            fontFamily: "shadow"
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Center(child: Text("homepage")),
    );
  }
}
