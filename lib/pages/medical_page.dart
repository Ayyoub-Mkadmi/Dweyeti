import 'package:flutter/material.dart';
import 'package:test/components/tile/med_tile.dart';

class MedicalPage extends StatelessWidget {
  const MedicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "دواياتي",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 3, // Number of medicines
          itemBuilder: (context, index) {
            return Column(children: [MedTile(), SizedBox(height: 20)]);
          },
        ),
      ),
    );
  }
}
