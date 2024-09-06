import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../api/api_root.dart';
import '../../themes/default_theme.dart';
import 'category_fetch.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class category_ui extends StatefulWidget {
  const category_ui({super.key});

  @override
  State<category_ui> createState() => _category_uiState();
}

class _category_uiState extends State<category_ui> {
  @override
  void initState() {
    super.initState();
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: AppBar(
        title: Text("Category"),
        backgroundColor: default_theme.white,
        scrolledUnderElevation: 0,
      ),
      body: categoryProvider.categories.isEmpty
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animation/empty.json',
                      repeat: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "No categories available",
                      style: default_theme.header_grey,
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1),
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];

                return GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Tapped on ${category.title} from all category");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    //same as width to make is square :)
                    margin: EdgeInsets.only(left: 10, right: 10),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            api_root + category.image,
                            //layout builder seems messy at this point and thats why used all the available screen of the device * 1 or 10% of the entire screen
                            // Made it same for square value
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
