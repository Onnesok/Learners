import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/api/api_root.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _rating = 0;

  Future<void> submitRating(String uemail, int appRating) async {
    final url = '${api_root}/submitAppRating.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'uemail': uemail,
        'app_rating': appRating.toString(),
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        Fluttertoast.showToast(msg: "Thank you for giving us: $_rating stars");
      } else {
        Fluttertoast.showToast(msg: '${responseData['message']}');
      }
    } else {
      Fluttertoast.showToast(msg: "Error occured : ${response.statusCode}");
      print('Failed to submit rating. Server responded: ${response.statusCode}');
    }
  }

  void _rate(int rating) {
    setState(() {
      _rating = rating;
      print(_rating);
    });
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Rate the App",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "shadow",
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Lottie.asset(
              'assets/animation/rate.json',
              repeat: true,
            ),
          ),

          const Text(
            "Please rate us",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => _rate(index + 1),
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 40,
                ),
              );
            }),
          ),

          SizedBox(height: 20,),

          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                elevation: 8,
              ),
                onPressed: () {
                submitRating(profileProvider.email, _rating);
                },
                child: Text(
                  "Send",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                  ),
                ),
            ),
          ),

        ],
      ),
    );
  }
}
