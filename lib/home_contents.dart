import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:learners/profile/profile_provider.dart';

class home_contents extends StatefulWidget {
  final Function(int) onTabChange;

  const home_contents({required this.onTabChange, super.key});

  @override
  State<home_contents> createState() => _home_contentsState();
}

class _home_contentsState extends State<home_contents> {

  Future<void> _NavToProfile() async {
    widget.onTabChange(3);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "learners",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "shadow",
              ),
            ),
            GestureDetector(
              onTap: _NavToProfile,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.orange,
                backgroundImage: profileProvider.pickedImage != null
                    ? FileImage(profileProvider.pickedImage!)
                    : AssetImage('assets/images/demo.jpg') as ImageProvider,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Center(child: Text("homepage")),
    );
  }
}
