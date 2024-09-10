import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';

class EnrolledCourseProvider with ChangeNotifier {
  List<EnrolledCourse> _courses = [];

  List<EnrolledCourse> get courses => _courses;

  Future<void> fetchCourses(String email) async {
    final url = Uri.parse('${api_root}/get_enrollment.php?email=$email');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') == true) {
          final data = jsonDecode(response.body);
          if (data is List) {
            _courses = data.map((item) => EnrolledCourse.fromJson(item)).toList();
          } else {
            print('Unexpected data format: ${data.runtimeType}');
            throw FormatException('Unexpected data format');
          }
          notifyListeners();
        } else {
          throw FormatException('Unexpected content type');
        }
      } else {
        throw Exception('Failed to load courses, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
      throw error;
    }
  }
}

class EnrolledCourse {
  final int courseId;
  final String title;
  final String instructorName;
  final String duration;
  final double price;
  final DateTime releaseDate;
  final String content;
  final String prerequisite;
  final int ratingCount;
  final int certificate;
  final String introVideo;
  final String image;
  final double stars;
  final String discount;
  final int categoryId;

  EnrolledCourse({
    required this.courseId,
    required this.title,
    required this.instructorName,
    required this.duration,
    required this.price,
    required this.releaseDate,
    required this.content,
    required this.prerequisite,
    required this.ratingCount,
    required this.certificate,
    required this.introVideo,
    required this.image,
    required this.stars,
    required this.discount,
    required this.categoryId,
  });

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) {
    return EnrolledCourse(
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      instructorName: json['instructor_name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      releaseDate: json['release_date'] != null ? DateTime.tryParse(json['release_date']) ?? DateTime.now() : DateTime.now(),
      content: json['content'] ?? '',
      prerequisite: json['prerequisite'] ?? '',
      ratingCount: json['rating_count'] ?? 0,
      certificate: json['certificate'] ?? 0,
      introVideo: json['intro_video'] ?? '',
      image: json['image'] ?? '',
      stars: json['stars'] != null ? double.tryParse(json['stars'].toString()) ?? 0.0 : 0.0,
      discount: json['discount'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }
}
