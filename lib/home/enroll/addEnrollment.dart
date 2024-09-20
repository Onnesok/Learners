import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../api/api_root.dart';


Future<void> addEnrollment(String email, int courseId) async {
  final Uri apiUrl = Uri.parse('${api_root}/enroll.php');

  final Map<String, dynamic> requestBody = {
    'uemail': email,
    'course_id': courseId,
  };

  try {
    final http.Response response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Enrollment added successfully',gravity: ToastGravity.CENTER, backgroundColor: Colors.orange);
    } else if (response.statusCode == 409) {
      Fluttertoast.showToast(msg: 'You are already enrolled in this course',gravity: ToastGravity.CENTER, backgroundColor: Colors.orange);
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: 'Bad request: ${response.body}');
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: "Server error 500",gravity: ToastGravity.CENTER, backgroundColor: Colors.orange);
    } else {
      Fluttertoast.showToast(msg: 'Unexpected error: ${response.statusCode} - ${response.body}',gravity: ToastGravity.CENTER, backgroundColor: Colors.orange);
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "An error occurred");
  }
}