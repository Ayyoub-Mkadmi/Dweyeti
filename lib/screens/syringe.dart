import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:flutter/services.dart'; // For rootBundle
// import 'package:intl/intl.dart';

class SyringePage extends StatefulWidget {
  @override
  _SyringePageState createState() => _SyringePageState();
}

class _SyringePageState extends State<SyringePage> {
  TextEditingController _medicineNameController = TextEditingController();
  List<TimeOfDay> _doseTimes = [];
  String _reminderFrequency = "كل نهار";
  Color _selectedColor = Colors.red; // Default chosen color

  @override
  void initState() {
    super.initState();
    _checkSvgFile();
  }

  void _checkSvgFile() async {
    try {
      await rootBundle.load('assets/icons/syringe.svg');
      print('SVG file loaded successfully');
    } catch (e) {
      print('Failed to load SVG file: $e');
    }
  }

  void _addDoseTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _doseTimes.add(pickedTime);
      });
    }
  }

  void _removeDoseTime(int index) {
    setState(() {
      _doseTimes.removeAt(index);
    });
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color; // Save the selected color
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Wave Background
            Stack(
              children: [
                // CustomPaint to draw the wave
                CustomPaint(
                  size: Size(double.infinity, 200), // Increased height
                  painter: WavePainter(),
                ),
                // Header: اختار الزريقة
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30, // Increased top padding
                    left: 24,
                    right: 16,
                  ), // Adjusted padding
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items at the top
                    children: [
                      // Custom syringe icon with selected color
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                        ), // Move down and to the right
                        child: SvgPicture.asset(
                          'assets/icons/syringe.svg', // Path to your SVG file
                          width: 80, // Increased size
                          height: 80,
                          color: _selectedColor, // Apply selected color
                          placeholderBuilder:
                              (BuildContext context) => Icon(
                                Icons.medical_services, // Fallback icon
                                size: 80,
                                color: _selectedColor,
                              ),
                        ),
                      ),
                      SizedBox(width: 16), // Space between syringe and text
                      // Text and color options on the right
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end, // Align to the right
                          children: [
                            // Text: اختار الزريقة
                            Text(
                              ": اختار الزريقة",
                              style: TextStyle(
                                fontSize: 22, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            // 6 color options in two rows of 3
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end, // Align to the right
                              children: [
                                // First row of 3 colors
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildColorOption(Colors.red),
                                    SizedBox(width: 16), // Increased gap
                                    _buildColorOption(Colors.blue),
                                    SizedBox(width: 16), // Increased gap
                                    _buildColorOption(Colors.green),
                                  ],
                                ),
                                SizedBox(height: 16), // Increased gap
                                // Second row of 3 colors
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildColorOption(Colors.yellow),
                                    SizedBox(width: 16), // Increased gap
                                    _buildColorOption(Colors.purple),
                                    SizedBox(width: 16), // Increased gap
                                    _buildColorOption(Colors.orange),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), // Increased space
            // Card 2: اسم الدواء
            Padding(
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
                        child: Text(
                          ": اسم الدواء",
                          style: TextStyle(
                            fontSize: 20, // Increased font size
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _medicineNameController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.medical_services,
                            color: Colors.blue[700],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "ادخل اسم الدواء",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card 3: قداه من مرة في النهار ؟
            Padding(
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
                        child: Text(
                          "قداه من مرة في النهار ؟",
                          style: TextStyle(
                            fontSize: 20, // Increased font size
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ..._doseTimes.asMap().entries.map((entry) {
                        int index = entry.key;
                        TimeOfDay time = entry.value;
                        return ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeDoseTime(index),
                          ),
                          title: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${time.format(context)}",
                              style: TextStyle(
                                fontSize: 18,
                              ), // Increased font size
                            ),
                          ),
                        );
                      }).toList(),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addDoseTime,
                          child: Text(
                            "إضافة وقت",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Increased font size
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card 4: قداه بش تفقد تشربو ؟
            Padding(
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
                        child: Text(
                          "قداه بش تفقد تشربو ؟",
                          style: TextStyle(
                            fontSize: 20, // Increased font size
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _reminderFrequency,
                        onChanged: (value) {
                          setState(() {
                            _reminderFrequency = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items:
                            ["كل نهار", "كل يومين", "كل 3 أيام"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ), // Increased font size
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Buttons: سجل and بطلت
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "سجل",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increased font size
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "بطلت",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increased font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add extra space at the bottom
          ],
        ),
      ),
    );
  }

  // Helper method to build color options
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6), // Add margin for spacing
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8), // Square with border radius
          border:
              _selectedColor == color
                  ? Border.all(
                    color: Colors.white,
                    width: 2,
                  ) // White border for selected color
                  : null,
        ),
      ),
    );
  }
}

// CustomPainter to draw the blue wave
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue[700]!
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7); // Start point
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4, // Control point 1
      size.width * 0.5,
      size.height * 0.7, // End point 1
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 1.0, // Control point 2
      size.width,
      size.height * 0.7, // End point 2
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
