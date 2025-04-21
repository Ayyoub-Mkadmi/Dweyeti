import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/components/tile/med_tile.dart';

class MedicalPage extends StatefulWidget {
  const MedicalPage({super.key});

  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  List<Medication> _medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  // Load medications from the database (e.g., Hive)
  Future<void> _loadMedications() async {
    var box = await Hive.openBox<Medication>('medications');
    List<Medication> medications = box.values.toList();

    setState(() {
      _medications = medications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "دواياتي",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _medications.isEmpty
                ? const Center(
                  child: CircularProgressIndicator(),
                ) // Show a loader if data is not yet loaded
                : ListView.builder(
                  itemCount: _medications.length, // Number of medications
                  itemBuilder: (context, index) {
                    // Get each medication
                    Medication medication = _medications[index];

                    return Column(
                      children: [
                        MedTile(
                          name: medication.name,
                          type:
                              medication
                                  .type, // Pass the name and type to MedTile
                        ), // Pass the medication to MedTile
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
