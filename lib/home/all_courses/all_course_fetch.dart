import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';

class AllCourse {
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
  final String videoContent;    // video contents
  final String description;
  final String videoTitle;
  final String prerequisite;
  final int ratingCount;
  final String certificate;
  final String introVideo;

  AllCourse({
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
    required this.videoContent,
    required this.description,
    required this.videoTitle,
    required this.prerequisite,
    required this.ratingCount,
    required this.certificate,
    required this.introVideo,
  });

  factory AllCourse.fromJson(Map<String, dynamic> json) {
    return AllCourse(
      categoryId: int.parse(json['category_id'].toString()),
      categoryTitle: json['category_title'] ?? 'Unknown Category',
      categoryImage: json['category_image'] ?? '',
      courseId: int.parse(json['course_id'].toString()),
      title: json['title'] ?? 'Unknown Title',
      image: json['image'] ?? '',
      stars: json['stars']?.toString() ?? '5',
      discount: json['discount'] ?? 'No',
      instructorName: json['instructor_name'] ?? 'Unknown Instructor',
      duration: json['duration'] ?? 'Unknown Duration',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown Release Date',
      videoContent: json['video_content'] ?? 'No content available',
      description: json['description'] ?? 'No description',
      videoTitle: json['video_title'] ?? 'No title available',
      prerequisite: json['prerequisite'] ?? 'No prerequisites',
      ratingCount: int.parse(json['rating_count'].toString()) ?? 0,
      certificate: json['certificate'] ?? 'No',
      introVideo: json['intro_video'] ?? '',
    );
  }
}


class AllCourseProvider with ChangeNotifier {
  List<AllCourse> _courses = [];

  List<AllCourse> get courses => _courses;

  Future<void> fetchAllCourses() async {
    const String uri = "${api_root}/all_courses.php";

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _courses = data.map((json) => AllCourse.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }
}
