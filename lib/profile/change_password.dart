import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _passEnable1 = true;
  bool _passEnable2 = true;
  bool _passEnable3 = true;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOldPasswordCorrect = true;
  int counter = 0;
  String? _password;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }
  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      _email = email;
    }
  }

  Future<void> _UserDbUpdate(String _password,String _email) async {
    final String apiUrl = 'http://104.247.108.10:3000/api/user/update/$_email';

    final Map<String, String> data = {
      "password": _password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Update successful!');
      Fluttertoast.showToast(msg: "Profile Updated", gravity: ToastGravity.TOP);
      print(response.body);
    } else {
      Fluttertoast.showToast(msg: "Error updating profile", gravity: ToastGravity.TOP);
      print('Update failed. Status code: ${response.statusCode}');
      print(response.body);
    }
  }

  void _togglePasswordVisibility1() {
    setState(() {
      _passEnable1 = !_passEnable1;
    });
  }
  void _togglePasswordVisibility2() {
    setState(() {
      _passEnable2 = !_passEnable2;
    });
  }
  void _togglePasswordVisibility3() {
    setState(() {
      _passEnable3 = !_passEnable3;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _passEnable1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isOldPasswordCorrect
                            ? Colors.black // Use black when password is correct
                            : Colors.red, // Use red for incorrect password
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isOldPasswordCorrect
                            ? Colors.orange
                            : Colors.red, // Use red for incorrect password
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    labelText: 'Current Password',
                    hintText: 'Current Password',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility1,
                      icon: Icon(
                        _passEnable1
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      color: Colors.black87.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password.';
                    } else if (!isOldPasswordCorrect) {
                      return 'Wrong password for current user.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _passEnable2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    labelText: 'New Password',
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility2,
                      icon: Icon(
                        _passEnable2
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      color: Colors.black87.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password.';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _passEnable3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility3,
                      icon: Icon(
                        _passEnable3
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      color: Colors.black87.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password.';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 500,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(20),
                      ),
                      onPressed: () {
                        Fluttertoast.showToast(msg: "Under construction");
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}