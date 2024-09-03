import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';

class Category {
  final String category_id;
  final String title;
  final String image;
  final int description;

  Category({
    required this.category_id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_id: json['category_id'] ?? 9999,
      title: json['title'] ?? 'Unknown Name',
      image: json['image'] ?? '',
      description : json['description'] ?? "No description provided",
    );
  }
}

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    const String uri = "${api_root}/categories.php";

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _categories = data.map((json) => Category.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }
}
