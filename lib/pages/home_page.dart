import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/data/models/history.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/data/repositories/history_repository.dart';
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
  late final MedicationRepository _medicationRepo;
  late final HistoryRepository _historyRepo;
  List<Medication> _medicationsForSelectedDay = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _medicationRepo = context.read<MedicationRepository>();
    _historyRepo = context.read<HistoryRepository>();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _medicationRepo.init();
      await _historyRepo.init();
      _fetchMedicationsForSelectedDay();
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint("Initialization error: $e");
      // Consider showing an error to the user
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _fetchMedicationsForSelectedDay() {
    try {
      final allMeds = _medicationRepo.getAllMedications();
      final medsForDay = <Medication>[];

      for (final med in allMeds) {
        for (final ord in med.ords) {
          final startDate = _normalizeDate(ord.startDate);
          final endDate = _normalizeDate(ord.endDate);
          final selectedDay = _normalizeDate(_selectedDay);

          if (selectedDay.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              selectedDay.isBefore(endDate.add(const Duration(days: 1)))) {
            medsForDay.add(med);
            break; // Add medication only once even if multiple ords match
          }
        }
      }

      setState(() {
        _medicationsForSelectedDay = medsForDay;
      });
    } catch (e) {
      debugPrint("Error fetching medications: $e");
    }
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
          contentPadding: const EdgeInsets.only(bottom: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      medicine.name,
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
              const SizedBox(height: 10),
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

  Future<void> _updateMedicineStatus(
    Medication medicine,
    String time,
    int newColorValue,
  ) async {
    try {
      final freshMed = await _medicationRepo.getMedication(medicine.id);
      if (freshMed == null) {
        debugPrint("Medication not found in box");
        return;
      }

      bool needsUpdate = false;
      final normalizedDay = _normalizeDate(_selectedDay);

      for (final ord in freshMed.ords) {
        if (_selectedDay.isAfter(
              ord.startDate.subtract(const Duration(days: 1)),
            ) &&
            _selectedDay.isBefore(ord.endDate.add(const Duration(days: 1)))) {
          // Initialize if null
          ord.dailyStatus ??= {};
          ord.dailyStatus![normalizedDay] ??= {};
          ord.history ??= [];

          // Update status
          ord.dailyStatus![normalizedDay]![time] = newColorValue;

          final status =
              newColorValue == Colors.green.value
                  ? "Taken"
                  : (newColorValue == Colors.grey.value
                      ? "Skipped"
                      : "Stopped");

          // Add history
          ord.history!.add({
            "date": _selectedDay.toIso8601String(),
            "time": time,
            "status": status,
          });

          // Save changes
          await ord.save();
          needsUpdate = true;

          // Add to history repository
          await _historyRepo.addHistory(
            History(
              medicationId: medicine.id,
              ordId: ord.idOrd,
              date: _selectedDay,
              time: time,
              status: status,
            ),
          );
        }
      }

      if (needsUpdate) {
        await _medicationRepo.addMedication(freshMed);
        _fetchMedicationsForSelectedDay();
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              selectedDecoration: const BoxDecoration(
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
            child:
                _medicationsForSelectedDay.isEmpty
                    ? const Center(
                      child: Text("No medications for selected day"),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(45),
                      itemCount: _medicationsForSelectedDay.length,
                      itemBuilder: (context, medIndex) {
                        try {
                          final med = _medicationsForSelectedDay[medIndex];
                          return Column(
                            children:
                                med.ords.expand((ord) {
                                  return ord.times.map((time) {
                                    final historyEntry = _historyRepo
                                        .getHistoryForOrdAndDate(
                                          ord.idOrd,
                                          _selectedDay,
                                        );

                                    Color tileColor;
                                    if (historyEntry != null) {
                                      tileColor =
                                          historyEntry.status == "Taken"
                                              ? Colors.green
                                              : historyEntry.status == "Skipped"
                                              ? Colors.grey
                                              : historyEntry.status == "Stopped"
                                              ? Colors.red
                                              : const Color.fromARGB(
                                                255,
                                                104,
                                                194,
                                                246,
                                              );
                                    } else {
                                      tileColor = const Color.fromARGB(
                                        255,
                                        104,
                                        194,
                                        246,
                                      );
                                    }

                                    return GestureDetector(
                                      onTap:
                                          () => _showMedicinePopup(
                                            context,
                                            med,
                                            time,
                                          ),
                                      child: Column(
                                        children: [
                                          ReminderTile(
                                            name: med.name,
                                            dose: '1 dose',
                                            time: time,
                                            color: tileColor,
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                }).toList(),
                          );
                        } catch (e) {
                          return ListTile(
                            title: const Text("Error loading medication"),
                            subtitle: Text(e.toString()),
                          );
                        }
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
