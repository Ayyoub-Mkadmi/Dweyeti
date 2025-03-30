import 'package:flutter/material.dart';
import 'package:test/constants/colors.dart';
import '../components/header.dart';
import '../components/cards/medicine_card.dart';
import '../components/cards/dose_times_card.dart';
import '../components/cards/treatment_period_card.dart';
import '../components/cards/notes_card.dart';
import '../components/buttons/action_button.dart';

abstract class MedicationFormPage extends StatefulWidget {
  final String medicineType;
  Widget customHeader;

  MedicationFormPage({
    required this.medicineType,
    required this.customHeader,
    Key? key,
  }) : super(key: key);
}

abstract class MedicationFormPageState<T extends MedicationFormPage>
    extends State<T> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<TimeOfDay> _doseTimes = [];
  Color _selectedColor = const Color.fromARGB(255, 214, 74, 64);
  DateTime? _startDate;
  DateTime? _endDate;
  Duration? _duration;

  Color get selectedColor => _selectedColor;

  bool get _isFormComplete {
    return _medicineNameController.text.isNotEmpty &&
        _doseTimes.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  void onColorSelected(Color color) {
    setState(() => _selectedColor = color);
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
        return Directionality(
          textDirection: TextDirection.rtl, // Ensures proper RTL alignment
          child: AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              "تأكيد الوصفة الطبية",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: mainColor, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.local_hospital,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Medicine name
                        Text(
                          "${_medicineNameController.text}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Notes (if available)
                        if (_notesController.text.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                " ملاحظات: ${_notesController.text}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),

                        // Dose Times
                        const Text(
                          " مواعيد الجرعات:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:
                              _doseTimes
                                  .map(
                                    (time) => Text(
                                      " ${time.format(context)}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 10),

                        // Treatment Period
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              " فترة العلاج: ",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " من ${_startDate!.toLocal().toString().split(' ')[0]} إلى ${_endDate!.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          "المدة: ${_duration!.inDays} يوم",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ تم حفظ المعلومات بنجاح")),
                  );
                },

                label: const Text("تأكيد"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),

                label: const Text("رجوع"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl, // Ensures proper RTL alignment
          child: AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "إلغاء العملية",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "هل أنت متأكد أنك تريد إلغاء العملية؟ سيتم فقدان جميع البيانات المدخلة.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Navigate back to home page
                },
                child: const Text("نعم"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("لا"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildConfirmationImage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0), // Added bottom margin
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.customHeader,
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
              NotesCard(
                controller: _notesController,
                onChanged: (_) => setState(() {}),
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
                      onPressed:
                          _isFormComplete ? _showConfirmationDialog : null,
                    ),
                    ActionButton(
                      label: "بطلت",
                      color: Colors.red,
                      onPressed: _showCancelConfirmationDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
