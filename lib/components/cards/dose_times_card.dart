import 'package:flutter/material.dart';

class DoseTimesCard extends StatelessWidget {
  final List<TimeOfDay> doseTimes;
  final VoidCallback onAddTime;
  final ValueChanged<int> onRemoveTime;

  const DoseTimesCard({
    required this.doseTimes,
    required this.onAddTime,
    required this.onRemoveTime,
    Key? key,
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
                  "قداه من مرة في النهار ؟",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 76, 201, 240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...doseTimes
                  .map(
                    (time) => ListTile(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () => onRemoveTime(doseTimes.indexOf(time)),
                      ),
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          time.format(context),
                          style: const TextStyle(fontSize: 23),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              Center(
                child: ElevatedButton(
                  onPressed: onAddTime,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "إضافة وقت",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 76, 201, 240),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      120,
                      40,
                    ), // Makes the button wider and taller
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ), // Additional padding
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
