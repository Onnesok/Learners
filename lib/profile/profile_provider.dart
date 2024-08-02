import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  File? _pickedImage;
  String _fname = 'No';
  String _lname = 'Name';

  File? get pickedImage => _pickedImage;
  String get fname => _fname;
  String get lname => _lname;
  String get fullName => '$_fname $_lname';

  ProfileProvider() {
    _loadProfile();
  }


  Future<void> _loadProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? fname = prefs.getString('first name');
      final String? lname = prefs.getString('last name');
      final String? imagePath = prefs.getString('profile_image');

      _fname = fname ?? 'No';
      _lname = lname ?? 'Name';
      if (imagePath != null && File(imagePath).existsSync()) {
        _pickedImage = File(imagePath);
      } else {
        _pickedImage = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
    }
  }


  Future<void> updateImage(File? newImage) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (newImage != null) {
        await prefs.setString('profile_image', newImage.path);
        _pickedImage = newImage;
      } else {
        await prefs.remove('profile_image');
        _pickedImage = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error updating image: $e');
    }
  }


  Future<void> updateName(String fname, String lname) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('first name', fname);
      await prefs.setString('last name', lname);
      _fname = fname;
      _lname = lname;
      notifyListeners();
    } catch (e) {
      print('Error updating names: $e');
    }
  }
}
