import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/header.dart';
import '../components/cards/medicine_card.dart';
import '../components/cards/dose_times_card.dart';
import '../components/cards/treatment_period_card.dart';
import '../components/buttons/action_button.dart';
// import '../models/medicine.dart';

class SachetPage extends StatefulWidget {
  @override
  _SachetPageState createState() => _SachetPageState();
}

class _SachetPageState extends State<SachetPage> {
  final TextEditingController _medicineNameController = TextEditingController();
  final List<TimeOfDay> _doseTimes = [];
  Color _selectedColor = Colors.red;
  DateTime? _startDate;
  DateTime? _endDate;
  Duration? _duration;

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

  bool get _isFormComplete {
    return _medicineNameController.text.isNotEmpty &&
        _doseTimes.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  Future<void> _addDoseTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
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
        _endDate = null;
        _duration = null;
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) return;

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

  void _setPeriod(int days) {
    if (_startDate == null) return;

    setState(() {
      _duration = Duration(days: days);
      _endDate = _startDate!.add(_duration!);
    });
  }

  void _showConfirmationDialog() {
    if (!_isFormComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء إكمال جميع الحقول المطلوبة")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد المعلومات", textAlign: TextAlign.right),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Your sachet SVG implementation here
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "اسم الدواء: ${_medicineNameController.text}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                const Text(
                  "مواعيد الجرعات:",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                ..._doseTimes
                    .map(
                      (time) => Text(
                        time.format(context),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    )
                    .toList(),
                const SizedBox(height: 10),
                Text(
                  "فترة العلاج: من ${_startDate!.toLocal().toString().split(' ')[0]} إلى ${_endDate!.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "المدة: ${_duration!.inDays} يوم",
                  style: const TextStyle(fontSize: 16),
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
                  const SnackBar(content: Text("تم حفظ المعلومات بنجاح")),
                );
              },
              child: const Text("تأكيد", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("رجوع", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
            MedicineHeader(
              selectedColor: _selectedColor,
              onColorSelected:
                  (color) => setState(() => _selectedColor = color),
              syringeSvgPath: 'assets/icons/sachet.svg',
              syringeSupSvgPath: 'assets/icons/sachet1sup.svg',
            ),
            const SizedBox(height: 30),
            MedicineCard(
              controller: _medicineNameController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            DoseTimesCard(
              doseTimes: _doseTimes,
              onAddTime: _addDoseTime,
              onRemoveTime: _removeDoseTime,
            ),
            const SizedBox(height: 20),
            TreatmentPeriodCard(
              startDate: _startDate,
              endDate: _endDate,
              duration: _duration,
              onSelectStartDate: _selectStartDate,
              onSelectEndDate: _selectEndDate,
              onSetPeriod: _setPeriod,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    label: "سجل",
                    color: Colors.green,
                    onPressed: _isFormComplete ? _showConfirmationDialog : null,
                  ),
                  ActionButton(
                    label: "بطلت",
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
