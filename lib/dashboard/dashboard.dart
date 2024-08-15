import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Dashboard",
          style: TextStyle(
            fontFamily: "shadow",
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.orange[700],
      ),
      
      body: Center(
        child: Text("This is the body of the dashboard"),
      ),
    );
  }
}
