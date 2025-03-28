import 'package:flutter/material.dart';
import 'package:test/constants/colors.dart';

class MedTile extends StatelessWidget {
  const MedTile({super.key});

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
            Text("Navilet", style: TextStyle(color: mainColor, fontSize: 25)),
            Image.asset(
              "assets/tile/Rectangle 27.png",
              height: 133,
              width: 133,
            ),

            // Arabic Text (Right-aligned)
          ],
        ),
      ),
    );
  }
}
