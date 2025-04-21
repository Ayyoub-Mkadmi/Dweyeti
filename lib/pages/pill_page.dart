import 'package:flutter/material.dart';
import 'package:test/pages/medication_form.dart';
import '../components/pillHeader.dart';
import '../data/repositories/medication_repository.dart'; // Add this import

class PillPage extends MedicationFormPage {
  PillPage({Key? key})
    : super(key: key, medicineType: 'Pill', customHeader: _buildPillHeader());

  @override
  _PillPageState createState() => _PillPageState();

  static Widget _buildPillHeader() {
    final pills = [
      PillItem(
        name: "تتشتش",
        imagePath: "assets/icons/tachtech.png",
        color: const Color.fromARGB(255, 6, 99, 177),
      ),
      PillItem(
        name: "دورة",
        imagePath: "assets/icons/doura.png",
        color: const Color.fromARGB(255, 231, 23, 20),
      ),
      PillItem(
        name: "كبسولة",
        imagePath: "assets/icons/capsule.png",
        color: const Color.fromARGB(255, 20, 161, 66),
      ),
      PillItem(
        name: "كبسولة يابسة",
        imagePath: "assets/icons/capsuleYebsa.png",
        color: const Color.fromARGB(255, 239, 83, 157),
      ),
    ];

    return PillHeader(
      pills: pills,
      onPillChanged: (index) {
        debugPrint("Selected pill: ${pills[index].name}");
      },
    );
  }
}

class _PillPageState extends MedicationFormPageState<PillPage> {
  @override
  Widget buildConfirmationImage() {
    return Container(
      color: selectedColor.withOpacity(0.2),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Your pill SVG implementation here
          ],
        ),
      ),
    );
  }
}
