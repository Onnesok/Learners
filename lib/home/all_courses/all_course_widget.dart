import 'package:flutter/material.dart';
import 'package:learners/home/all_courses/all_course_fetch.dart';
import 'package:learners/home/enroll_course.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:provider/provider.dart';

import '../../api/api_root.dart';

class CourseListView extends StatefulWidget {
  const CourseListView({super.key});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      final allCourseProvider =
      Provider.of<AllCourseProvider>(context, listen: false);
      allCourseProvider.fetchAllCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCourseProvider = Provider.of<AllCourseProvider>(context);

    if (allCourseProvider.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: allCourseProvider.courses.length,
      itemBuilder: (context, index) {
        final course = allCourseProvider.courses[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => enroll(
                  title: course.title,
                  image: api_root + course.image,
                  stars: course.stars,
                  discount: course.discount,
                  //duration: course.duration,
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            color: default_theme.white,
            child: Row(
              children: [
                course.image.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    api_root + course.image,
                    width: MediaQuery.of(context).size.width * 0.4, // Adjust width to cover half of the tile
                    height: MediaQuery.of(context).size.width * 0.25, // Adjust height accordingly
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
                    },
                  ),
                )
                    : const Icon(Icons.image, size: 100),
                SizedBox(width: 8.0), // Space between image and text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0),
                        Text('Instructor: ${course.instructorName}'),
                        Text('Category: ${course.categoryTitle}'),
                        Text('Duration: ${course.duration}'),
                        Text('Price: \$${course.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
