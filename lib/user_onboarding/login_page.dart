import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/home_page.dart';
import 'package:learners/user_onboarding/registration.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  bool passEnable = true;
  bool isPasswordcorrect = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                ),
                SizedBox(height: 6,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                            hintText: "Email",
                            focusColor: Colors.amber,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
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
                            hintText: "password",
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(passEnable
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye),
                              color: Colors.black38,
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 8 || isPasswordcorrect == false){
                              return "please enter correct password";
                            }
                            return null;
                          },
                        ),
                      ),


                      //////////// button ///////////////
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Fluttertoast.showToast(msg: 'Not implemented yet', gravity: ToastGravity.TOP);
                          },
                          child: Text(
                            'Forgot password',
                            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.all(18),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page()));
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(fontSize: 18, letterSpacing: .4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: TextStyle(letterSpacing: .6, wordSpacing: 2, fontSize: 14),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => registration()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.amber, letterSpacing: 1),
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
    );
  }
}
