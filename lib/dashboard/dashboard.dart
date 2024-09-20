import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/dashboard/course_video.dart';
import 'package:learners/dashboard/enrolled_course_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../api/api_root.dart';
import '../home/all_courses/all_courses.dart';
import '../profile/profile_provider.dart';
import '../themes/default_theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final email = profileProvider.email;
    final enrolledCourseProvider = Provider.of<EnrolledCourseProvider>(context);

    // Fetch data when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      enrolledCourseProvider.fetchCourses(email);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: default_theme.appbar_orange,
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DashboardItem(title: "Your courses"),
      ),
    );
  }
}







class DashboardItem extends StatefulWidget {
  final String title;

  const DashboardItem({super.key, required this.title});

  @override
  State<DashboardItem> createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  late Future<void> _fetchCoursesFuture;

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final enrolledCourseProvider =
        Provider.of<EnrolledCourseProvider>(context, listen: false);
    final email = profileProvider.email;
    _fetchCoursesFuture = enrolledCourseProvider.fetchCourses(email);
  }

  @override
  Widget build(BuildContext context) {
    final enrolledCourseProvider = Provider.of<EnrolledCourseProvider>(context);

    return FutureBuilder<void>(
      future: _fetchCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,   // width for making it square :)
                  child: Lottie.asset(
                    "assets/animation/loader2.json",
                  ),
                ),
                SizedBox(height: 30,),
                Text("Loading....", style: default_theme.body_grey,),
              ],
            ),
          );
        } else if (enrolledCourseProvider.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.title,
                    style: default_theme.title,
                  ),
                ),
                Divider(),
                Lottie.asset(
                  'assets/animation/empty.json',
                  repeat: true,
                ),
                Text('No enrolled courses', style: default_theme.header_grey),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseListView(category: "All"),
                        ),
                      ),
                    },
                    child: Text("See courses ?"),
                  ),
                ),
              ],
            ),
          );
        }

        // Fetch and sort the courses
        List<EnrolledCourse> filteredCourses = enrolledCourseProvider.courses;
        filteredCourses.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        //filteredCourses = filteredCourses.take(2).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  style: default_theme.title,
                ),
              ),
              Divider(),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/s1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseVideo(
                              videoContent: course.title,
                              videoTitle: course.title,
                            ),

                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image,
                                            size: 50);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.image, size: 100),

                            const SizedBox(width: 8.0),
                            // Space between image and text

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4.0),
                                    Text(
                                        'Instructor: ${course.instructorName}'),
                                    Text('Duration: ${course.duration}'),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Continue Course",
                                          style: default_theme.body_grey,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseListView(category: "All"),
                      ),
                    ),
                  },
                  child: Text("See courses ?"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
