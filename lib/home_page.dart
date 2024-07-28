import 'package:flutter/material.dart';

class home_page extends StatelessWidget {
  const home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Center(
          child: Text("hello there internet user"),
      ),
    );
  }
}
