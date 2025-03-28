import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:test/pages/pill_page.dart';
import 'package:test/pages/sachet_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syringe App',
      theme: ThemeData(primarySwatch: Colors.blue),
      //home: SyringePage(),
      //home: SachetPage(),
      //home: PillPage(),
    );
  }
}

class SyringePage extends StatefulWidget {
  @override
  _SyringePageState createState() => _SyringePageState();
}

class _SyringePageState extends State<SyringePage> {
  final TextEditingController _medicineNameController = TextEditingController();
  final List<TimeOfDay> _doseTimes = [];
  Color _selectedColor = Colors.red;

  DateTime? _startDate;
  DateTime? _endDate;
  Duration? _duration;

  bool get _isFormComplete {
    return _medicineNameController.text.isNotEmpty &&
        _doseTimes.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  @override
  void initState() {
    super.initState();
    _checkSvgFile();
  }

  Future<void> _checkSvgFile() async {
    try {
      await rootBundle.load('assets/icons/syringe.svg');
      print('SVG file loaded successfully');
    } catch (e) {
      print('Failed to load SVG file: $e');
    }
  }

  Future<void> _addDoseTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _doseTimes.add(pickedTime));
    }
  }

  void _removeDoseTime(int index) {
    setState(() => _doseTimes.removeAt(index));
  }

  void _selectColor(Color color) {
    setState(() => _selectedColor = color);
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _endDate = null;
        _duration = null;
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء اختيار تاريخ البدء أولاً")),
      );
      return;
    }

    final picked = await showDatePicker(
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

  void _setPeriod(int days) {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء اختيار تاريخ البدء أولاً")),
      );
      return;
    }

    setState(() {
      _duration = Duration(days: days);
      _endDate = _startDate!.add(_duration!);
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    if (!_isFormComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء إكمال جميع الحقول المطلوبة")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد المعلومات", textAlign: TextAlign.right),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/syringe.svg',
                        width: 100,
                        height: 100,
                        color: _selectedColor,
                        placeholderBuilder:
                            (BuildContext context) => Icon(
                              Icons.medical_services,
                              size: 100,
                              color: _selectedColor,
                            ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/syringe1sup.svg',
                        width: 100,
                        height: 100,
                        placeholderBuilder:
                            (BuildContext context) => Icon(
                              Icons.medical_services,
                              size: 100,
                              color: Colors.white.withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "اسم الدواء: ${_medicineNameController.text}",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 10),
                Text(
                  "مواعيد الجرعات:",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                ..._doseTimes
                    .map(
                      (time) => Text(
                        time.format(context),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    )
                    .toList(),
                SizedBox(height: 10),
                Text(
                  "فترة العلاج: من ${_startDate!.toLocal().toString().split(' ')[0]} إلى ${_endDate!.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "المدة: ${_duration!.inDays} يوم",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم حفظ المعلومات بنجاح")),
                );
              },
              child: Text("تأكيد", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("رجوع", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border:
              _selectedColor == color
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, int days) {
    return ElevatedButton.icon(
      onPressed: () => _setPeriod(days),
      icon: Icon(Icons.date_range, color: Colors.white),
      label: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (label == "سجل") {
          _showConfirmationDialog(context);
        } else {
          // Handle cancel button
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: Size(double.infinity, 200),
                  painter: WavePainter(),
                ),
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
                              color: _selectedColor,
                              placeholderBuilder:
                                  (BuildContext context) => Icon(
                                    Icons.medical_services,
                                    size: 80,
                                    color: _selectedColor,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ": اختار الزريقة",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildColorOption(Colors.red),
                                    SizedBox(width: 16),
                                    _buildColorOption(Colors.blue),
                                    SizedBox(width: 16),
                                    _buildColorOption(Colors.green),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildColorOption(Colors.yellow),
                                    SizedBox(width: 16),
                                    _buildColorOption(Colors.purple),
                                    SizedBox(width: 16),
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
            SizedBox(height: 30),
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
                            fontSize: 20,
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
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                            fontSize: 20,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ..._doseTimes
                          .map(
                            (time) => ListTile(
                              leading: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _removeDoseTime(
                                      _doseTimes.indexOf(time),
                                    ),
                              ),
                              title: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  time.format(context),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addDoseTime,
                          child: Text(
                            "إضافة وقت",
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                            fontSize: 20,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _selectStartDate,
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            _startDate == null
                                ? "اختر تاريخ البدء"
                                : "تاريخ البدء: ${_startDate!.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _selectEndDate,
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            _endDate == null
                                ? "اختر تاريخ الانتهاء"
                                : "تاريخ الانتهاء: ${_endDate!.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPeriodButton("أسبوع", 7),
                          _buildPeriodButton("أسبوعين", 14),
                          _buildPeriodButton("شهر", 30),
                        ],
                      ),
                      SizedBox(height: 10),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        _isFormComplete
                            ? () => _showConfirmationDialog(context)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFormComplete ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "سجل",
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue[700]!
          ..style = PaintingStyle.fill;
    final path =
        Path()
          ..moveTo(0, size.height * 0.9)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.7,
            size.width * 0.5,
            size.height * 1,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height * 1.2,
            size.width * 1,
            size.height * 0.9,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
