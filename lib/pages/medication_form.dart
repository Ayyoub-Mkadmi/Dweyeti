import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:test/components/cards/notes_card.dart';
import 'package:test/pages/visualization.dart';
import 'package:uuid/uuid.dart';
import '../data/models/medication.dart';
import '../data/models/ord.dart';
import '../data/repositories/medication_repository.dart';
import '../components/header.dart';
import '../components/cards/medicine_card.dart';
import '../components/cards/dose_times_card.dart';
import '../components/cards/treatment_period_card.dart';
import '../components/buttons/action_button.dart';

abstract class MedicationFormPage extends StatefulWidget {
  final String medicineType;
  Widget customHeader;
  // final MedicationRepository repository;

  MedicationFormPage({
    required this.medicineType,
    required this.customHeader,
    // required this.repository,
    Key? key,
  }) : super(key: key);
}

abstract class MedicationFormPageState<T extends MedicationFormPage>
    extends State<T> {
  final TextEditingController _medicineNameController = TextEditingController();
  final List<TimeOfDay> _doseTimes = [];
  Color _selectedColor = Colors.red;
  DateTime? _startDate;
  DateTime? _endDate;
  Duration? _duration;
  late final MedicationRepository _repository;
  final Uuid _uuid = Uuid();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = Provider.of<MedicationRepository>(context, listen: false);
  }

  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _medicineNameController.dispose();
    super.dispose();
  }

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

  Future<void> _saveMedication() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء تحديد تاريخ البداية والنهاية")),
      );
      return;
    }
    final times =
        _doseTimes.map((time) => "${time.hour}:${time.minute}").toList();

    final newOrd = Ord(
      idOrd: _uuid.v4(),
      times: times,
      notes: _notesController.text,
      history: [],
      startDate: _startDate!, // Add start date
      endDate: _endDate!, // Add end date
    );

    try {
      // First try to find existing medication
      final existingMeds = _repository.getAllMedications();
      final existingMed = existingMeds.firstWhere(
        (m) => m.name == _medicineNameController.text,
        orElse:
            () =>
                Medication(id: '', name: '', ords: [], type: '', colorValue: 0),
      );

      if (existingMed.id.isNotEmpty) {
        // Add new ORD to existing medication
        await _repository.addOrdToMedication(existingMed.id, newOrd);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم إضافة جرعة جديدة للدواء الموجود")),
        );
      } else {
        // Create new medication
        final newMedication = Medication(
          id: _uuid.v4(),
          name: _medicineNameController.text,
          ords: [newOrd],
          type: widget.medicineType,
          colorValue: _selectedColor.value,
        );
        await _repository.addMedication(newMedication);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم حفظ الدواء بنجاح")));
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الحفظ: ${e.toString()}")),
      );
    }
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
          backgroundColor: Colors.white, // Background color to keep it clean
          titlePadding: EdgeInsets.all(16.0),
          title: Row(
            children: [
              Icon(
                Icons.medical_services,
                color: Colors.green,
                size: 30,
              ), // Medical icon
              SizedBox(width: 10),
              const Text(
                "تأكيد المعلومات",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Confirmation image or icon
                buildConfirmationImage(),
                const SizedBox(height: 20),

                // Medication Name
                Text(
                  " ${_medicineNameController.text}",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),

                // Dose times
                const Text(
                  "مواعيد الجرعات:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
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

                // Treatment period
                Text(
                  "فترة العلاج: من ${_startDate!.toLocal().toString().split(' ')[0]} إلى ${_endDate!.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),

                // Duration
                Text(
                  "المدة: ${_duration!.inDays} يوم",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),

                // Separator line for a clean section
                Divider(color: Colors.grey.shade300),

                // Action buttons styled like receipt confirmation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Confirm button
                      ElevatedButton(
                        onPressed: _saveMedication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Green confirmation button
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          "تأكيد",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Cancel button
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red cancel button
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          "رجوع",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      body: SingleChildScrollView(
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
                    onPressed: _isFormComplete ? _showConfirmationDialog : null,
                  ),
                  ActionButton(
                    label: "بطلت",
                    color: Colors.red,
                    onPressed: () {},
                  ),
                  ActionButton(
                    label: "عرض البيانات",
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HiveViewerPage(),
                        ),
                      );
                    },
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
