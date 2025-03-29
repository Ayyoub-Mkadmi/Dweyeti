import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:test/components/bottom_nav_bar.dart';
import 'package:test/components/tile/reminder_tile.dart';

import 'package:test/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDay = DateTime.now(); // Selected date

  final Map<DateTime, List<Map<String, dynamic>>> medicineData = {
    DateTime(2025, 03, 28): [
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {
        'name': 'Navilet',
        'dose': '1/4',
        'time': '08:00',
        'color': Colors.green,
      },
      {'name': 'Navilet', 'dose': '1/4', 'time': '10:00', 'color': Colors.red},
    ],
    DateTime(2025, 03, 27): [
      {
        'name': 'Paracetamol',
        'dose': '1',
        'time': '15:00',
        'color': Colors.red,
      },
    ],
  };

  // Normalize the date to remove time and match it with the medicine data
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day); // Normalize to midnight
  }

  void _showMedicinePopup(BuildContext context, Map<String, dynamic> medicine) {
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
                      medicine['name'],
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Dose: ${medicine['dose']}",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 5),

              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "خذيتو",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                onPressed: () => Navigator.pop(context),
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

  @override
  Widget build(BuildContext context) {
    print(_selectedDay);
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

          // Button to go back to today's date
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDay = DateTime.now(); // Set to today
              });
            },
            child: const Text('💙', style: TextStyle(fontSize: 20)),
          ),

          const SizedBox(height: 10),

          // Dynamic Calendar
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.week, // Shows only one week
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
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

          // Medicine List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(45),
              itemCount:
                  medicineData[_normalizeDate(_selectedDay)]?.length ?? 0,
              itemBuilder: (context, index) {
                var med = medicineData[_normalizeDate(_selectedDay)]![index];
                return GestureDetector(
                  onTap: () => _showMedicinePopup(context, med),
                  child: Column(
                    children: [
                      ReminderTile(
                        name: med['name'],
                        dose: med['dose'],
                        time: med['time'],
                        color: med['color'],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      //bottomNavigationBar: BottomNavBar(),
    );
  }
}
