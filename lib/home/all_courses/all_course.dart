import 'package:flutter/material.dart';
import 'package:learners/themes/default_theme.dart';
import 'all_course_widget.dart';

class all_course extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: default_theme.white,
        appBar: AppBar(
          title: Text('Courses'),
          backgroundColor: default_theme.white,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),

        body: CourseListView(), //CourseListView(courseList: courses),
      );
  }
}
