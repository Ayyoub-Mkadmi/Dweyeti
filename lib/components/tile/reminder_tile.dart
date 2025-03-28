import 'package:flutter/material.dart';

class ReminderTile extends StatelessWidget {
  final String name;
  final String dose;
  final String time;
  final Color color;
  const ReminderTile({
    super.key,
    required this.name,
    required this.dose,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 131,
      width: 293,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade100), // Optional border
      ),
      child: Stack(
        children: [
          // Box state Bottom Bar
          Positioned(
            bottom: 0,
            child: Container(
              width: 293,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
          ),

          // Pills Illustration
          Positioned(
            right: 20,
            top: 10,
            child: Stack(
              children: [
                // First pill (orange with red stripe)
                Transform.rotate(
                  angle: 0.3, // Slight tilt
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 10,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),

                // Second pill (yellow with yellow stripe)
              ],
            ),
          ),

          // Text Information
          Positioned(
            left: 20,
            top: 15,
            child: Row(
              children: [
                Text(
                  dose,
                  style: TextStyle(
                    color: Colors.blue.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.blue.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Arabic Text (Right-aligned)
          Positioned(
            left: 20,
            top: 50,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
