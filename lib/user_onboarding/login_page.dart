import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/home_page.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:learners/user_onboarding/registration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  bool passEnable = true;
  bool isPasswordcorrect = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    //const String uri = "http://10.0.2.2/learners_api/login.php";
    const String uri = "http://192.168.0.104/learners_api/login.php";

    final body = {
      'email': email,
      'password': password,
    };
    // Send the POST request
    final response = await http.post(
      Uri.parse(uri),
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == 'true') {
        final user = jsonResponse['user'];
        final String firstName = user['fname'];
        final String lastName = user['lname'];
        final String userEmail = user['email'];

        // Handle data here bro :)
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.updateName(firstName, lastName);
        await profileProvider.storeEmail(userEmail);
        Fluttertoast.showToast(msg: "welcome $firstName");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const home_page()));
      } else {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      Fluttertoast.showToast(msg: "Error failed to login");
      print('Failed to login. Status code: ${response.statusCode}');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      passEnable = !passEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 0, top: 0),
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
                              return "Please enter your email";
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 0, top: 0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: passEnable,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isPasswordcorrect
                                    ? Colors.amber
                                    : Colors.red,
                              ),
                            ),
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
                              return "Please enter your password";
                            } else if (value.length < 8) {
                              return "Password must be at least 8 characters long";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 30),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: 'Not implemented yet',
                                gravity: ToastGravity.TOP);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const home_page()),
                            );
                          },
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                                if (_formKey.currentState!.validate()) {
                                  login(_emailController.text,
                                      _passwordController.text);
                                }
                              },
                              child: const Text(
                                "Sign In",
                                style:
                                    TextStyle(fontSize: 18, letterSpacing: .4, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  letterSpacing: .6,
                                  wordSpacing: 2,
                                  fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const registration()));
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.orange,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold),
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
    );
  }
}
