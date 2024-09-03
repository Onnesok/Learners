import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';

class PopularCourse {
  final String title;
  final String image;
  final String stars;
  final String discount;
  final String categoryTitle;
  final String instructorName;
  final String duration;
  final double price;

  PopularCourse({
    required this.title,
    required this.image,
    required this.stars,
    this.discount = "No",
    required this.categoryTitle,
    required this.instructorName,
    required this.duration,
    required this.price,
  });

  factory PopularCourse.fromJson(Map<String, dynamic> json) {
    return PopularCourse(
      title: json['course_title'] ?? 'Unknown Title',
      image: json['course_image'] ?? '',
      stars: json['stars']?.toString() ?? '5',
      discount: json['discount'] ?? 'No',
      categoryTitle: json['category_title'] ?? 'Unknown Category',
      instructorName: json['instructor_name'] ?? 'Unknown Instructor',
      duration: json['duration'] ?? 'Unknown Duration',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}

class PopularCourseProvider with ChangeNotifier {
  List<PopularCourse> _courses = [];

  List<PopularCourse> get courses => _courses;

  Future<void> fetchPopularCourses() async {
    const String uri = "${api_root}/popular_courses.php";

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
