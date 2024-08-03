import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';
import 'package:http/http.dart' as http;

class edit_profile extends StatefulWidget {
  @override
  _edit_profileState createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  bool passEnable = true;
  bool isPasswordcorrect = true;
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _togglePasswordVisibility() {
    setState(() {
      passEnable = !passEnable;
    });
  }

  Future<void> updateUserProfile(
      String email, String password, String newFname, String newLname) async {
    const String uri = "http://192.168.1.13/learners_api/edit_profile.php";

    final body = {
      'email': email,
      'password': password,
      'new_fname': newFname,
      'new_lname': newLname,
    };

    final response = await http.post(
      Uri.parse(uri),
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == 'true') {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.updateName(
            _fnameController.text, _lnameController.text);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '${data['message']}');
        print('Profile updated: ${data['message']}');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${data['message']}');
        print('Error: ${data['message']}');
      }
    } else {
      print('Failed to update profile. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    _fnameController.text = profileProvider.fname;
    _lnameController.text = profileProvider.lname;
    _emailController.text = profileProvider.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.orange[800],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _fnameController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                          labelText: 'First Name',
                          hintText: 'First Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          } else if (RegExp(r'\d').hasMatch(value)) {
                            return "please enter valid name";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(width: 10.0),

                    Expanded(
                      child: TextFormField(
                        controller: _lnameController,
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Last Name",
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your last name";
                          } else if (RegExp(r'\d').hasMatch(value)) {
                            return "please enter valid name";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Email Address",
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: passEnable,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Password",
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isPasswordcorrect ? Colors.amber : Colors.red,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(passEnable
                          ? Icons.visibility_off
                          : Icons.remove_red_eye),
                      color: Colors.black38,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters long";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20,),

                Center(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 100,
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
                        if (_formKey.currentState!.validate()) {
                          updateUserProfile(
                            _emailController.text,
                            _passwordController.text,
                            _fnameController.text,
                            _lnameController.text,
                          );
                        }
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18, letterSpacing: .4),
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
