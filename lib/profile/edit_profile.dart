import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
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

      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 10),
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
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: _lnameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
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
            ),


            SizedBox(height: 20),


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
                  onPressed: () async {
                    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                    await profileProvider.updateName(_fnameController.text, _lnameController.text);
                    Navigator.pop(context);
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
    );
  }
}
