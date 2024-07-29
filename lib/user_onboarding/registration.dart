import 'package:flutter/material.dart';
import 'package:learners/user_onboarding/login_page.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {

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
            image: AssetImage('assets/images/registration.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2,),
              Text(
                "Please Create Your Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6,),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                /*   padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width/2 - 50,
                    right: MediaQuery.of(context).size.width/2 - 50,
                    top: MediaQuery.of(context).size.height/4,
                    bottom: MediaQuery.of(context).size.height/4,
                  ),*/
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                hintText: 'First Name',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _firstNameController.text.isNotEmpty
                                        ? Colors.red
                                        : Colors.amber,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter First Name';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: "Last Name",
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _lastNameController.text.isNotEmpty
                                        ? Colors.red
                                        : Colors.amber,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Last Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

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
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 0),
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
                          hintText: "Confirm password",
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
                    Center(
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
                          onPressed: () {},
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, letterSpacing: .4),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?", style: TextStyle(letterSpacing: .6, wordSpacing: 2, fontSize: 14),),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
                            },
                            child: Text(
                              'Sign In',
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
