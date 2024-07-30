import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

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
  File? _pickedImage;
  late SharedPreferences _prefs;
  String _fname = 'No';
  String _lname = 'Name';

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  void _signOut() async {
    try {
      // await _auth.signOut();
      // await GoogleSignIn().signOut();
      //Fluttertoast.showToast(msg: 'Logged out successfully');
      // Remove specific keys from SharedPreferences
      await _prefs.remove('first name');
      await _prefs.remove('last name');
      await _prefs.remove('email');
      await _prefs.remove('gender');
      await _prefs.remove('profile_image');

      // Navigate to the login page and remove the bottom navigation bar
      Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new login()));

      ScaffoldMessenger.of(context).showSnackBar(    //hmmmmm cant use snackbar as it's stacking the screen... or snacking :V
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

    ////// ok checking if user is a googler
    // final user = _auth.currentUser;
    // if (user != null && user.providerData.any((info) => info.providerId == 'google.com')) {
    //   setState(() {
    //     _isLoggedInWithGoogle = true;
    //   });
    // }

    if (fname != null) {
      setState(() {
        _fname = fname;
      });
    }
    if (lname != null) {
      setState(() {
        _lname = lname;
      });
    }

    // Load the image after loading the data
    await _loadImage();
  }


  Future<void> _loadImage() async {
    final String? imagePath = _prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _pickedImage = File(imagePath);
      });
    } else {
      setState(() {
        _pickedImage = null; // Reset _pickedImage if imagePath is null
      });
    }
  }


  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      await _prefs.setString('profile_image', pickedFile.path);
      //Fluttertoast.showToast(msg: "profile updated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'profile picture updated',
                style: TextStyle(color: Colors.white, fontSize: 16,),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200,
            left: 30,
            right: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _editProfile() async {
    Fluttertoast.showToast(msg: "Not done yet");
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EditProfilePage()),
    // );

    // Reload data after editing profile
    _loadData();
  }

  Future<void> _changepass() async {
    Fluttertoast.showToast(msg: "Not done yet");
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ChangePassword()),
    // );

    _loadData();
  }

  Future<void> _address() async {
    Fluttertoast.showToast(msg: "Not done yet");
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Address()),
    // );

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                FutureBuilder<void>(
                  future: _loadImage(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading image'));
                    } else {
                      return GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.orange,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : AssetImage('assets/icon/logo1.png') as ImageProvider,
                          ),
                        ),
                      );
                    }
                  },
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
              _fname + " " + _lname,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Divider(),
            ListTileItem(icon: Icons.person_outline_rounded, text: 'Edit profile', onTap: _editProfile,),
            if (!_isLoggedInWithGoogle) ListTileItem(icon: Icons.lock_outline, text: 'Change Password', onTap: _changepass,),
            ListTileItem(icon: Icons.location_on_outlined, text: 'Address', onTap: _address,),
/*            ListTileItem(icon: Icons.notifications_none_outlined, text: 'Notification'),
            ListTileItem(icon: Icons.monetization_on_outlined, text: 'payment'),
            ListTileItem(icon: Icons.security_outlined, text: 'Security'),
            ListTileItem(icon: Icons.translate_outlined, text: 'Language'),
            ListTileItem(icon: Icons.privacy_tip_outlined, text: 'Privacy Policy'),
            ListTileItem(icon: Icons.help_outline_outlined, text: 'Help Center'),
            ListTileItem(icon: Icons.share_outlined, text: 'Invite Friends'),*/
            ListTileItem(icon: Icons.logout, text: 'Logout', onTap: _signOut,),
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
        color: text == 'Logout'
            ? Colors.red
            : Colors.black87.withOpacity(0.7),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: text == 'Logout' ? Colors.red : Colors.black,
              ),
            ),
          ),
          if (text != 'Logout') Icon(Icons.arrow_forward_ios),
        ],
      ),
      onTap: onTap,
    );
  }
}