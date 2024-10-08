import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learners/profile/change_password.dart';
import 'package:learners/profile/edit_profile.dart';
import 'package:learners/profile/rate_app.dart';
import 'package:learners/profile/report.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/enrolled_course_provider.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black87),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: const ProfilePage(),
    );
  }
}



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Provider.of<EnrolledCourseProvider>(context, listen: false).clearCourses();
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.updateImage(null);
      profileProvider.updateName("No", "Name");
      profileProvider.storeEmail("");
      await prefs.setBool('isLoggedIn', false);

      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => const login()),
      );

      _showSnackBar('Logged out successfully');
    } catch (e) {
      _showToast('Error signing out: $e');
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ProfileProvider>(context, listen: false).updateImage(File(pickedFile.path));
      _showToast('Profile picture updated');
    }
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _showToast(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Image.asset(
              'assets/icon/app_icon1.png',
              fit: BoxFit.contain,
              height: 30,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Color(0xfffcce7e),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _shareApp() {
    print("Share option tapped");
    Share.share(
      'Check out this amazing platform! Get onboard and start exploring: https://github.com/Onnesok/learners',
      subject: 'Invite to Join the Platform',
    );
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              alignment: Alignment.bottomRight,
              children: [

                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      backgroundImage: profileProvider.pickedImage != null
                          ? FileImage(profileProvider.pickedImage!) as ImageProvider<Object>?
                          : const AssetImage('assets/images/demo.jpg'),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              profileProvider.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10.0),

            const Divider(thickness: 0.3,),

            ListTileItem(icon: Icons.person_outline_rounded, text: 'Edit Profile', onTap: () => _navigateTo(const edit_profile())),
            ListTileItem(icon: Icons.lock_outline, text: 'Change Password', onTap: () => _navigateTo(const ChangePassword())),
            ListTileItem(icon: Icons.school_outlined, text: 'Become Instructor', onTap: () => _showToast('Not Applicable right now')),
            ListTileItem(icon: Icons.share_outlined, text: 'Share app', color: Colors.orange[800], onTap: () => _shareApp() ),
            ListTileItem(icon: Icons.star_border_outlined, text: 'Rate Us', onTap: () => _navigateTo(const RatingPage()) ),
            ListTileItem(icon: Icons.contact_page_outlined, text: 'Contact us', onTap: () => _showToast('Not done yet')),
            ListTileItem(icon: Icons.bug_report_outlined, text: 'Report a bug', onTap: () => _navigateTo(ReportBugScreen())),
            ListTileItem(icon: Icons.logout, text: 'Logout', onTap: _signOut),
          ],
        ),
      );
  }
}


class ListTileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? color;

  const ListTileItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? (text == 'Logout' ? Colors.red : Colors.black87.withOpacity(0.7)),
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
          if (text != 'Logout') const Icon(Icons.arrow_forward_ios),
        ],
      ),
      onTap: onTap,
    );
  }
}
