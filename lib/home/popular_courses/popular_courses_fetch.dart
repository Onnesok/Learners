import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';

class PopularCourse {
  final int categoryId;
  final String categoryTitle;
  final String categoryImage;
  final int courseId;
  final String title;
  final String image;
  final String stars;
  final String discount;
  final String instructorName;
  final String duration;
  final double price;
  final String releaseDate;
  final String content;
  final String prerequisite;
  final int ratingCount;
  final bool certificate;
  final String introVideo;

  PopularCourse({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryImage,
    required this.courseId,
    required this.title,
    required this.image,
    required this.stars,
    this.discount = "No",
    required this.instructorName,
    required this.duration,
    required this.price,
    required this.releaseDate,
    required this.content,
    required this.prerequisite,
    required this.ratingCount,
    required this.certificate,
    required this.introVideo,
  });

  factory PopularCourse.fromJson(Map<String, dynamic> json) {
    return PopularCourse(
      categoryId: int.parse(json['category_id'].toString()),
      categoryTitle: json['category_title'] ?? 'Unknown Category',
      categoryImage: json['category_image'] ?? '',
      courseId: int.parse(json['course_id'].toString()),
      title: json['course_title'] ?? 'Unknown Title',
      image: json['course_image'] ?? '',
      stars: json['stars']?.toString() ?? '5',
      discount: json['discount'] ?? 'No',
      instructorName: json['instructor_name'] ?? 'Unknown Instructor',
      duration: json['duration'] ?? 'Unknown Duration',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown Release Date',
      content: json['content'] ?? '',
      prerequisite: json['prerequisite'] ?? 'None',
      ratingCount: int.parse(json['rating_count'].toString()) ?? 0,
      certificate: json['certificate'] == '1',
      introVideo: json['intro_video'] ?? '',
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
