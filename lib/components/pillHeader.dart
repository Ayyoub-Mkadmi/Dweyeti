import 'package:flutter/material.dart';
import 'wave_painter.dart';

class PillHeader extends StatefulWidget {
  final List<PillItem> pills;
  final ValueChanged<int>? onPillChanged;

  const PillHeader({required this.pills, this.onPillChanged, Key? key})
    : super(key: key);

  @override
  _PillHeaderState createState() => _PillHeaderState();
}

class _PillHeaderState extends State<PillHeader> {
  int _currentIndex = 0;

  void _previousPill() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % widget.pills.length;
      if (_currentIndex < 0) _currentIndex = widget.pills.length - 1;
      widget.onPillChanged?.call(_currentIndex);
    });
  }

  void _nextPill() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.pills.length;
      widget.onPillChanged?.call(_currentIndex);
    });
  }

  Widget _buildPillImage(PillItem pill) {
    return Image.asset(
      pill.imagePath,
      width: 80,
      height: 80,
      fit: BoxFit.contain,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return _buildPlaceholder(pill);
      },
    );
  }

  Widget _buildPlaceholder(PillItem pill) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: pill.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.medication, size: 40, color: pill.color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPill = widget.pills[_currentIndex];

    return Stack(
      children: [
        // Wavy background
        SizedBox(
          width: double.infinity,
          height: 170,
          child: CustomPaint(painter: WavePainter()),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              // Right-aligned text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      const TextSpan(text: "اختر الحرومشة : "),
                      TextSpan(
                        text: currentPill.name,
                        style: TextStyle(color: currentPill.color),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Centered pill with arrows
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: _previousPill,
                    ),

                    // Pill image with error handling
                    Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildPillImage(currentPill),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: _nextPill,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PillItem {
  final String name;
  final String imagePath; // Changed from svgPath to imagePath
  final Color color;

  const PillItem({
    required this.name,
    required this.imagePath, // Changed from svgPath to imagePath
    required this.color,
  });
}
