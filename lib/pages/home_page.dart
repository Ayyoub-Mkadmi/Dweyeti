import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/data/models/medication.dart';
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
  List<Medication> _medicationsForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _medicationRepo = Provider.of<MedicationRepository>(context, listen: false);
    await _medicationRepo.init();
    _fetchMedicationsForSelectedDay();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _fetchMedicationsForSelectedDay() {
    List<Medication> allMeds = _medicationRepo.getAllMedications();
    List<Medication> medsForDay = [];

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
          medsForDay.add(med);
        }
      }
    }

    setState(() {
      _medicationsForSelectedDay = medsForDay;
    });
  }

  void _showMedicinePopup(
    BuildContext context,
    Medication medicine,
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
                      medicine.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      time, // Show selected time
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
                      _updateMedicineStatus(medicine, time, Colors.green.value);
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
                      _updateMedicineStatus(medicine, time, Colors.grey.value);
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
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _updateMedicineStatus(medicine, time, Colors.red.value);
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

  void _updateMedicineStatus(
    Medication medicine,
    String time,
    int newColorValue,
  ) async {
    var box = await Hive.openBox<Medication>('medications');

    for (var ord in medicine.ords) {
      if (_selectedDay.isAfter(
            ord.startDate.subtract(const Duration(days: 1)),
          ) &&
          _selectedDay.isBefore(ord.endDate.add(const Duration(days: 1)))) {
        // Ensure dailyStatus map exists for the selected day
        DateTime normalizedDay = _normalizeDate(_selectedDay);

        // Make sure the dailyStatus is mutable
        if (ord.dailyStatus[normalizedDay] == null ||
            ord.dailyStatus[normalizedDay] is Map == false) {
          ord.dailyStatus[normalizedDay] =
              {}; // Create a new mutable map if not already a map
        }

        // Update the status for the specific time slot
        ord.dailyStatus[normalizedDay]![time] = newColorValue;

        // Track status history
        String status =
            (newColorValue == Colors.green.value)
                ? "Taken"
                : (newColorValue == Colors.grey.value)
                ? "Skipped"
                : "Stopped";

        ord.history.add({
          "date": _selectedDay.toIso8601String(),
          "time": time,
          "status": status,
        });

        await ord.save();
      }
    }

    // Save the updated medication
    await medicine.save();
    // Re-fetch medications for the selected day
    _fetchMedicationsForSelectedDay();
    // Refresh the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FAFC),
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
                _fetchMedicationsForSelectedDay();
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
                _fetchMedicationsForSelectedDay();
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color(0xFF4CC9F0),
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
              itemCount: _medicationsForSelectedDay.length,
              itemBuilder: (context, medIndex) {
                Medication med = _medicationsForSelectedDay[medIndex];

                return Column(
                  children:
                      med.ords.expand((ord) {
                        return ord.times.map((time) {
                          // Retrieve the status from the dailyStatus map
                          int tileColor =
                              ord.getStatus(_selectedDay, time) ??
                              Colors.blue.value; // Default color

                          return GestureDetector(
                            onTap: () => _showMedicinePopup(context, med, time),
                            child: Column(
                              children: [
                                ReminderTile(
                                  name: med.name,
                                  dose: '1 dose',
                                  time: time,
                                  color: Color(tileColor),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        }).toList();
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
