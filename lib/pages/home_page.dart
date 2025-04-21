import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/data/models/ord.dart';
import 'package:test/data/repositories/medication_repository.dart';

import '../components/tile/reminder_tile.dart';
import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDay = DateTime.now();
  MedicationRepository _medicationRepo = MedicationRepository();
  List<Map<String, dynamic>> _ordsForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _medicationRepo = Provider.of<MedicationRepository>(context, listen: false);
    await _medicationRepo.init();
    _fetchOrdsForSelectedDay();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _fetchOrdsForSelectedDay() {
    List<Medication> allMeds = _medicationRepo.getAllMedications();
    List<Map<String, dynamic>> ordsList = [];

    for (var med in allMeds) {
      for (var ord in med.ords) {
        DateTime startDate = _normalizeDate(ord.startDate);
        DateTime endDate = _normalizeDate(ord.endDate);
        if (_normalizeDate(
              _selectedDay,
            ).isAfter(startDate.subtract(const Duration(days: 1))) &&
            _normalizeDate(
              _selectedDay,
            ).isBefore(endDate.add(const Duration(days: 1)))) {
          for (var time in ord.times) {
            ordsList.add({'medication': med, 'ord': ord, 'time': time});
          }
        }
      }
    }

    setState(() {
      _ordsForSelectedDay = ordsList;
    });
  }

  void _showOrdPopup(
    BuildContext context,
    Medication med,
    Ord ord,
    String time,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.only(bottom: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateOrdStatus(ord, time, Colors.green.value);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "خذيتو",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateOrdStatus(ord, time, Colors.grey.value);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      "مزلت",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _updateOrdStatus(ord, time, Colors.red.value);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "بطلت",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateOrdStatus(Ord ord, String time, int newColorValue) async {
    print("Updating status for Ord on $_selectedDay at $time");

    final selectedMed = _medicationRepo.getAllMedications().firstWhere(
      (med) => med.ords.contains(ord),
      orElse:
          () => throw Exception("Medication not found for the selected Ord."),
    );

    // Find the actual Ord object inside the medication and update it
    final index = selectedMed.ords.indexOf(ord);
    if (index == -1) return;

    final realOrd = selectedMed.ords[index];

    realOrd.updateStatus(_selectedDay, time, newColorValue);
    await selectedMed.save();

    realOrd.history.add({
      "date": _selectedDay.toIso8601String(),
      "time": time,
      "status":
          (newColorValue == Colors.green.value)
              ? "Taken"
              : (newColorValue == Colors.grey.value)
              ? "Skipped"
              : "Stopped",
    });

    // Save the parent Medication instead of the Ord
    if (selectedMed.isInBox) {
      await selectedMed.save();
      print("Medication with updated Ord saved.");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            '! مرحبا بيك ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDay = DateTime.now();
                _fetchOrdsForSelectedDay();
              });
            },
            child: const Text('💙', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 10),
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _fetchOrdsForSelectedDay();
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: const Color(0xFF4CC9F0),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(45),
              itemCount: _ordsForSelectedDay.length,
              itemBuilder: (context, index) {
                final entry = _ordsForSelectedDay[index];
                final Medication med = entry['medication'];
                final Ord ord = entry['ord'];
                final String time = entry['time'];

                int tileColor =
                    ord.getStatus(_selectedDay, time) ?? Colors.blue.value;

                return GestureDetector(
                  onTap: () => _showOrdPopup(context, med, ord, time),
                  child: Column(
                    children: [
                      ReminderTile(
                        name: med.name,
                        dose: '1 dose',
                        time: time,
                        color: Color(tileColor),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
