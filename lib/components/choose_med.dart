import 'package:flutter/material.dart';
import 'package:test/constants/colors.dart';

class ChooseMed extends StatelessWidget {
  final void Function()? onTap;
  final String med;
  final String imagePath;
  const ChooseMed({
    super.key,
    required this.med,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: mainColor.withValues(), // Shadow color
              blurRadius: 0, // Spread of the shadow
              offset: const Offset(3, 4), // Vertical displacement
            ),
          ],
          color: backgroundColor,
        ),

        width: 214,
        height: 68,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                med,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Image.asset(imagePath, width: 50, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
