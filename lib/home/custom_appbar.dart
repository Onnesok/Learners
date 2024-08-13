import 'package:flutter/material.dart';
import 'package:learners/profile/profile_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onTabChange;
  final ProfileProvider profileProvider;

  const CustomAppBar({super.key, required this.onTabChange, required this.profileProvider});

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "learners",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              fontFamily: "shadow",
            ),
          ),
          GestureDetector(
            onTap: () => onTabChange(3),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profileProvider.fullName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 3 * 3.14159 / 2,
                          child: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black87,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        const Text(
                          "Status: User",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10,),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange,
                  backgroundImage: profileProvider.pickedImage != null
                      ? FileImage(profileProvider.pickedImage!)
                      : const AssetImage('assets/images/demo.jpg') as ImageProvider,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange[800],
      shadowColor: Colors.transparent,
      shape: const CustomAppBarShape(multi: 0.08),
    );
  }
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  final double multi;
  const CustomAppBarShape({this.multi = 0.1});
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double height = rect.height;
    double width = rect.width;
    var path = Path();
    path.lineTo(0, height + width * multi);
    path.arcToPoint(
      Offset(width * multi, height),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width * (1 - multi), height);
    path.arcToPoint(
      Offset(width, height + width * multi),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }
}