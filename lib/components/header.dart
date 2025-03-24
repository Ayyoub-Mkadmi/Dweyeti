import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'color_picker.dart';
import 'wave_painter.dart';

class MedicineHeader extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const MedicineHeader({
    required this.selectedColor,
    required this.onColorSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(size: Size(double.infinity, 200), painter: WavePainter()),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 24, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/syringe.svg',
                      width: 80,
                      height: 80,
                      color: selectedColor,
                      placeholderBuilder:
                          (BuildContext context) => Icon(
                            Icons.medical_services,
                            size: 80,
                            color: selectedColor,
                          ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/syringe1sup.svg',
                      width: 80,
                      height: 80,
                      placeholderBuilder:
                          (BuildContext context) => Icon(
                            Icons.medical_services,
                            size: 80,
                            color: Colors.white.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ColorPicker(
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
