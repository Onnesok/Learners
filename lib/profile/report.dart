import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../api/api_root.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  late TextEditingController _issueController;

  Future<void> submitBugReport(String email) async {
    final url = '${api_root}/bugReport.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'uemail': email,
          'issue_description': _issueController.text,
        },
      );

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['message']),
        ));
        _issueController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['message']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit bug report. Please try again.'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _issueController = TextEditingController();
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: AppBar(
        title: Text("Report an Issue"),
        centerTitle: true,
        backgroundColor: default_theme.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/share.png',
                  height: 250,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Your Issue',
                  style: default_theme.header,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: const Text(
                  'Please describe your issue as clearly as possible',
                  textAlign: TextAlign.center,
                ),
              ),
              _buildComposer(),
              const SizedBox(height: 50,),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  onPressed: () {
                    submitBugReport(profileProvider.email);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: default_theme.orangeButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: default_theme.orange.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        Icons.bubble_chart_outlined,
                        color: default_theme.white,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Send Issue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: default_theme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: default_theme.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 200,
            ),
            color: default_theme.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _issueController,
                maxLines: null,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 16,
                  color: default_theme.darkGrey,
                ),
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your Issue...',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
