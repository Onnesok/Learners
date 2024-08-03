import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Category {
  final String name;
  final String image;
  final int courseCount;

  Category({
    required this.name,
    required this.image,
    required this.courseCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      image: json['image'],
      courseCount: json['courseCount'],
    );
  }
}

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    //const String uri = "http://10.0.2.2/learners_api/login.php";
    const String uri = "http://192.168.1.13/learners_api/categories.php";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _categories = data.map((json) => Category.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}