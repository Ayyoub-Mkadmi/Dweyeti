import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    required this.selectedColor,
    required this.onColorSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          ": اختار الزريقة",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildColorOption(Colors.red),
                SizedBox(width: 16),
                _buildColorOption(Colors.blue),
                SizedBox(width: 16),
                _buildColorOption(Colors.green),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildColorOption(const Color.fromARGB(255, 237, 101, 33)),
                SizedBox(width: 16),
                _buildColorOption(Colors.purple),
                SizedBox(width: 16),
                _buildColorOption(Colors.orange),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border:
              selectedColor == color
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
        ),
      ),
    );
  }
}
