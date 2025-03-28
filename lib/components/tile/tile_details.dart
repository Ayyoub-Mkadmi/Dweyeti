import 'package:flutter/material.dart';

class TileDetails extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const TileDetails({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showBottomSheet(context),
      child: const Text("Show Details"),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                medicine['name'] ?? 'Unknown Medicine',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("💊 Dose: ${medicine['dose'] ?? 'N/A'}"),
              const SizedBox(height: 5),
              Text("⏰ Time: ${medicine['time'] ?? 'N/A'}"),
              const SizedBox(height: 20),
              _buildButton(context, "بطلت", Colors.red),
              _buildButton(context, "خذيتو", Colors.green),
              _buildButton(context, "مزلت", Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
