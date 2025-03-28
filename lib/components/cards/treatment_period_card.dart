import 'package:flutter/material.dart';
import '../buttons/period_button.dart';

class TreatmentPeriodCard extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Duration? duration;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;
  final ValueChanged<int> onSetPeriod;

  const TreatmentPeriodCard({
    Key? key,
    this.startDate,
    this.endDate,
    this.duration,
    required this.onSelectStartDate,
    required this.onSelectEndDate,
    required this.onSetPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: const Text(
                  "قداه بش تقعد تشربو ؟",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 76, 201, 240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onSelectStartDate,
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 76, 201, 240),
                    ),
                  ),
                  Text(
                    startDate == null
                        ? "اختر تاريخ البدء"
                        : "تاريخ البدء: ${startDate!.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onSelectEndDate,
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 76, 201, 240),
                    ),
                  ),
                  Text(
                    endDate == null
                        ? "اختر تاريخ الانتهاء"
                        : "تاريخ الانتهاء: ${endDate!.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PeriodButton(
                    label: "أسبوع",
                    days: 7,
                    onPressed: () => onSetPeriod(7),
                  ),
                  PeriodButton(
                    label: "أسبوعين",
                    days: 14,
                    onPressed: () => onSetPeriod(14),
                  ),
                  PeriodButton(
                    label: "شهر",
                    days: 30,
                    onPressed: () => onSetPeriod(30),
                  ),
                ],
              ),
              if (duration != null) ...[
                const SizedBox(height: 10),
                Text(
                  "المدة: ${duration!.inDays} يوم",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 76, 201, 240),
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
