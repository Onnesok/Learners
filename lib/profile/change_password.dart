import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

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
  String? _email;

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _email = profileProvider.email;
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  Future<void> updatePassword(String email, String currentPassword, String newPassword) async {
    const String uri = "${api_root}/change_password.php";

    final body = {
      'email': email,
      'current_password': currentPassword,
      'new_password': newPassword,
    };

    final response = await http.post(
      Uri.parse(uri),
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == 'true') {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsonResponse['message']);
      } else {
        Fluttertoast.showToast(msg: jsonResponse['message']);
      }
    } else {
      Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Change password"),
        backgroundColor: Colors.orange[700],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,

            child: Column(
              children: [

                const SizedBox(height: 20),

                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _passEnable1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isOldPasswordCorrect
                            ? Colors.black
                            : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isOldPasswordCorrect
                            ? Colors.orange
                            : Colors.red,
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
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
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

                const SizedBox(height: 20),

                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _passEnable2,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
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
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                      ),
                      color: Colors.black87.withOpacity(0.6),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password.';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    } else if (value == _oldPasswordController.text) {
                      return 'New password cant be old password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _passEnable3,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
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
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
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

                const SizedBox(height: 20),

                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await updatePassword(
                          _email!,
                          _oldPasswordController.text,
                          _newPasswordController.text,
                        );

                        // password wrong hoile clear korar dorkar ase ?

                        //_oldPasswordController.clear();
                        //_newPasswordController.clear();
                        //_confirmPasswordController.clear();
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(fontSize: 18, letterSpacing: 1, color: Colors.white),
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
