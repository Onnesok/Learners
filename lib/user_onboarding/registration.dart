import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'package:http/http.dart' as http;

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final _formKey = GlobalKey<FormState>();
  bool passEnable = true;
  bool cpassEnable = true;
  bool isPasswordcorrect = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> insert_record() async {

    if (_formKey.currentState!.validate()) {
      try {
        // make POST request
        //const String uri = "http://10.0.2.2/learners_api/sign_up.php";
        const String uri = "http://192.168.1.13/learners_api/sign_up.php";
        var response = await http.post(
            Uri.parse(uri),
            body: {
              "fname": _firstNameController.text,
              "lname": _lastNameController.text,
              "email": _emailController.text,
              "password": _passwordController.text
        });

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse["success"] == "true") {
          Fluttertoast.showToast(msg: "Registration successful");
          Fluttertoast.showToast(msg: "Please login");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const login()
            ),
          );
          print("Record inserted");
        } else {
          Fluttertoast.showToast(msg: "${jsonResponse['message']}");
          print(jsonResponse);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Please fill all fields correctly");
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      passEnable = !passEnable;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      cpassEnable = !cpassEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/registration.png'),
              fit: BoxFit.cover,
            ),
          ),

          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "Please Create Your Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 40),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      hintText: 'First Name',
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _firstNameController.text.isNotEmpty
                                              ? Colors.red
                                              : Colors.amber,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.amber),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your First Name';
                                      } else if (RegExp(r'\d').hasMatch(value)) {
                                        return "please enter valid name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10.0),

                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      hintText: "Last Name",
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _lastNameController.text.isNotEmpty
                                              ? Colors.red
                                              : Colors.amber,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.amber),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Last Name';
                                      } else if (RegExp(r'\d').hasMatch(value)) {
                                        return "please enter valid name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: passEnable,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isPasswordcorrect ? Colors.amber : Colors.red,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                hintText: "Password",
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
                                  return 'Please enter your Password';
                                } else if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 0),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: cpassEnable,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isPasswordcorrect ? Colors.amber : Colors.red,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                hintText: "Confirm Password",
                                suffixIcon: IconButton(
                                  onPressed: _toggleConfirmPasswordVisibility,
                                  icon: Icon(cpassEnable
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye),
                                  color: Colors.black38,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your Password';
                                } else if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[800],
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(18),
                                ),
                                onPressed: () {
                                  insert_record();
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 18, letterSpacing: .4),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    letterSpacing: .6,
                                    wordSpacing: 2,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const login()),
                                    );
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
