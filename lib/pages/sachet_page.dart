import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/pages/medication_form.dart';
import '../components/header.dart';

class SachetPage extends MedicationFormPage {
  SachetPage({Key? key})
    : super(
        key: key,
        medicineType: 'Sachet',
        customHeader: MedicineHeader(
          selectedColor: Colors.red,
          onColorSelected: (color) {},
          syringeSvgPath: 'assets/icons/sachet.svg',
          syringeSupSvgPath: 'assets/icons/sachet1sup.svg',
        ),
      );

  @override
  _SachetPageState createState() => _SachetPageState();
}

class _SachetPageState extends MedicationFormPageState<SachetPage> {
  @override
  void initState() {
    super.initState();
    _checkSvgFile();
  }

  Future<void> _checkSvgFile() async {
    try {
      await rootBundle.load('assets/icons/sachet.svg');
    } catch (e) {
      debugPrint('Failed to load SVG file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.customHeader = MedicineHeader(
      selectedColor: selectedColor,
      onColorSelected: onColorSelected,
      syringeSvgPath: 'assets/icons/sachet.svg',
      syringeSupSvgPath: 'assets/icons/sachet1sup.svg',
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
            // Your sachet SVG implementation here
          ],
        ),
      ),
    );
  }
}
