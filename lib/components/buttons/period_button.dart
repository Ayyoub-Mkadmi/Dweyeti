import 'package:flutter/material.dart';

class PeriodButton extends StatelessWidget {
  final String label;
  final int days;
  final VoidCallback onPressed;

  const PeriodButton({
    required this.label,
    required this.days,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 76, 201, 240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
