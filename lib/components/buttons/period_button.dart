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
      icon: Icon(Icons.date_range, color: Colors.white),
      label: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
