import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PopularCourse {
  final String title;
  final String image;
  final String stars;
  final String discount;

  PopularCourse({
    required this.title,
    required this.image,
    required this.stars,
    this.discount = "No",
  });

  factory PopularCourse.fromJson(Map<String, dynamic> json) {
    return PopularCourse(
      title: json['title'] ?? 'Unknown Title',
      image: json['image'] ?? '',
      stars: json['stars']?.toString() ?? '5',
      discount: json['discount'] ?? 'No',
    );
  }

}

class PopularCourseProvider with ChangeNotifier {
  List<PopularCourse> _courses = [];

  List<PopularCourse> get courses => _courses;

  Future<void> fetchPopularCourses() async {
    const String uri = "http://192.168.0.104/learners_api/popular_courses.php";
    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _courses = data.map((json) => PopularCourse.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load popular courses');
      }
    } catch (error) {
      print('Error fetching popular courses: $error');
    }
  }
}
