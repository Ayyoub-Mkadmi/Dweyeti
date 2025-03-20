import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:flutter/services.dart'; // For rootBundle

class SyringePage extends StatefulWidget {
  @override
  _SyringePageState createState() => _SyringePageState();
}

class _SyringePageState extends State<SyringePage> {
  TextEditingController _medicineNameController = TextEditingController();
  List<TimeOfDay> _doseTimes = [];
  Color _selectedColor = Colors.red; // Default chosen color

  // State variables for the calendar feature
  DateTime? _startDate;
  DateTime? _endDate;
  Duration? _duration;

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

  // Function to show the calendar and select a start date
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _endDate = null; // Reset end date when start date changes
        _duration = null; // Reset duration when start date changes
      });
    }
  }

  // Function to show the calendar and select an end date
  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a start date first.")),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _duration = _endDate!.difference(_startDate!);
      });
    }
  }

  // Function to set the period and calculate the end date
  void _setPeriod(int days) {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a start date first.")),
      );
      return;
    }

    setState(() {
      _duration = Duration(days: days);
      _endDate = _startDate!.add(_duration!);
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
                        child: Stack(
                          alignment: Alignment.center, // Center the images
                          children: [
                            // Existing syringe image
                            SvgPicture.asset(
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
                            // New syringe image on top
                            SvgPicture.asset(
                              'assets/icons/syringe1sup.svg', // Path to the new SVG file
                              width: 80, // Same size as the existing one
                              height: 80,
                              placeholderBuilder:
                                  (BuildContext context) => Icon(
                                    Icons.medical_services, // Fallback icon
                                    size: 80,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                            ),
                          ],
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
                      // Start Date Button
                      ElevatedButton(
                        onPressed: _selectStartDate,
                        child: Text(
                          _startDate == null
                              ? "اختر تاريخ البدء"
                              : "تاريخ البدء: ${_startDate!.toLocal().toString().split(' ')[0]}",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // End Date Button
                      ElevatedButton(
                        onPressed: _selectEndDate,
                        child: Text(
                          _endDate == null
                              ? "اختر تاريخ الانتهاء"
                              : "تاريخ الانتهاء: ${_endDate!.toLocal().toString().split(' ')[0]}",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Period Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _setPeriod(7),
                            child: Text(
                              "أسبوع",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _setPeriod(14),
                            child: Text(
                              "أسبوعين",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _setPeriod(30),
                            child: Text(
                              "شهر",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Display Duration
                      if (_duration != null)
                        Text(
                          "المدة: ${_duration!.inDays} يوم",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[700],
                          ),
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
    path.moveTo(0, size.height * 0.9); // Start point
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.7, // Control point 1
      size.width * 0.5,
      size.height * 1, // End point 1
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 1.2, // Control point 2
      size.width * 1,
      size.height * 0.9, // End point 2
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
