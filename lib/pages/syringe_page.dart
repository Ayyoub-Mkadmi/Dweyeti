import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/pages/medication_form.dart';
import '../components/header.dart';
import '../data/repositories/medication_repository.dart';

class SyringePage extends MedicationFormPage {
  SyringePage({Key? key})
    : super(
        key: key,
        medicineType: 'Syringe',
        customHeader: MedicineHeader(
          selectedColor: Colors.red,
          onColorSelected: (color) {},
          syringeSvgPath: 'assets/icons/syringe.svg',
          syringeSupSvgPath: 'assets/icons/syringe_sup.svg',
        ),
      );

  @override
  _SyringePageState createState() => _SyringePageState();
}

class _SyringePageState extends MedicationFormPageState<SyringePage> {
  @override
  void initState() {
    super.initState();
    _checkSvgFile();
  }

  Future<void> _checkSvgFile() async {
    try {
      await rootBundle.load('assets/icons/syringe.svg');
    } catch (e) {
      debugPrint('Failed to load SVG file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.customHeader = MedicineHeader(
      selectedColor: selectedColor,
      onColorSelected: onColorSelected,
      syringeSvgPath: 'assets/icons/syringe.svg',
      syringeSupSvgPath: 'assets/icons/syringe_sup.svg',
    );
    return super.build(context);
  }

  @override
  Widget buildConfirmationImage() {
    return Container(
      color: selectedColor.withOpacity(0.2),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Your syringe SVG implementation here
            // Example:
            // SvgPicture.asset('assets/icons/syringe.svg'),
          ],
        ),
      ),
    );
  }
}
