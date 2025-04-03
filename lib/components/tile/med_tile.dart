import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/constants/colors.dart';

class MedTile extends StatelessWidget {
  final String name; // Example name, replace with actual data
  final String type; // Type of the medication ('pill', 'syringe', 'sachet')

  const MedTile({super.key, required this.name, required this.type});

  // Function to return the correct image based on medication type
  String _getImageForType(String type) {
    switch (type.toLowerCase()) {
      case 'pill':
        return "assets/tile/Rectangle3.png";
      case 'syringe':
        return "assets/tile/Rectangle2.png";
      case 'sachet':
        return "assets/tile/Rectangle1.png";
      default:
        return "assets/icons/doura.png"; // Default to pills image if unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: mainColor), // Optional border
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(color: mainColor, fontSize: 15)),
            // Display the image based on medication type
            SvgPicture.asset(
              _getImageForType(type), // Dynamically select image
              height: 133,
              width: 133,
            ),
          ],
        ),
      ),
    );
  }
}
