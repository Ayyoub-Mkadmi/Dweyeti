import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MedicineCard({
    required this.controller,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: const Text(
                  ": اسم الدواء",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.medical_services,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "ادخل اسم الدواء",
                ),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
