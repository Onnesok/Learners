import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learners/profile/edit_profile.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggedInWithGoogle = false;
  final ImagePicker _imagePicker = ImagePicker();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _signOut() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.updateImage(null);
      profileProvider.updateName("No", "Name");

      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => login(),),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Image.asset(
                'assets/icon/logo1.png',
                fit: BoxFit.contain,
                height: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Logged out successfully',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out: $e', gravity: ToastGravity.TOP);
      print("Error signing out: $e");
    }
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    final String? fname = _prefs.getString('first name');
    final String? lname = _prefs.getString('last name');

    if (fname != null && lname != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateName(fname, lname);
    }

    _loadImage();
  }

  Future<void> _loadImage() async {
    final String? imagePath = _prefs.getString('profile_image');
    if (imagePath != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateImage(File(imagePath));
    } else {
      Provider.of<ProfileProvider>(context, listen: false).updateImage(null);
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateImage(File(pickedFile.path));
      await _prefs.setString('profile_image', pickedFile.path);

      Fluttertoast.showToast(msg: 'Profile picture updated', gravity: ToastGravity.TOP);
    }
  }

  Future<void> _editProfile() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
    //_loadData();
  }

  Future<void> _changepass() async {
    Fluttertoast.showToast(msg: "Not done yet");
    _loadData();
  }

  Future<void> _address() async {
    Fluttertoast.showToast(msg: "Not done yet");
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      backgroundImage: profileProvider.pickedImage != null
                          ? FileImage(profileProvider.pickedImage!)
                          : AssetImage('assets/images/demo.jpg') as ImageProvider,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              profileProvider.fname + " " + profileProvider.lname,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Divider(),
            ListTileItem(icon: Icons.person_outline_rounded, text: 'Edit profile', onTap: _editProfile),
            if (!_isLoggedInWithGoogle) ListTileItem(icon: Icons.lock_outline, text: 'Change Password', onTap: _changepass),
            ListTileItem(icon: Icons.payments_outlined, text: 'Payment details', onTap: _address),
            ListTileItem(icon: Icons.verified_outlined, text: 'Verify', onTap: _address),
            ListTileItem(icon: Icons.contact_page_outlined, text: 'contact us', onTap: _address),
            ListTileItem(icon: Icons.location_on_outlined, text: 'Address', onTap: _address),
            ListTileItem(icon: Icons.bug_report_outlined, text: 'Report a bug', onTap: _address),
            ListTileItem(icon: Icons.logout, text: 'Logout', onTap: _signOut),
          ],
        ),
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  ListTileItem({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: text == 'Logout' ? Colors.red : Colors.black87.withOpacity(0.7),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: text == 'Logout' ? Colors.red : Colors.black),
            ),
          ),
          if (text != 'Logout') Icon(Icons.arrow_forward_ios),
        ],
      ),
      onTap: onTap,
    );
  }
}
