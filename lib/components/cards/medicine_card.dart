import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MedicineCard({required this.controller, this.onChanged, Key? key})
    : super(key: key);

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
                    color: Color.fromARGB(255, 76, 201, 240),
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
                    color: Color.fromARGB(255, 76, 201, 240),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 76, 201, 240),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 76, 201, 240),
                      width: 2.0,
                    ),
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
