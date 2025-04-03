import 'package:hive/hive.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/data/models/ord.dart';

class MedicationRepository {
  Box<Medication>? _medicationsBox; // Nullable now

  Future<void> init() async {
    _medicationsBox = await Hive.openBox<Medication>('medications');
  }

  Future<void> addMedication(Medication medication) async {
    try {
      if (_medicationsBox == null) {
        throw Exception("Medication box has not been initialized.");
      }

      // Check if medication with same name exists
      final existingMed = _medicationsBox!.values.firstWhere(
        (m) => m.name.toLowerCase() == medication.name.toLowerCase(),
        orElse:
            () =>
                Medication(id: '', name: '', ords: [], type: '', colorValue: 0),
      );

      if (existingMed.id.isNotEmpty) {
        // Medication exists - add new ORD to it
        existingMed.ords.addAll(medication.ords);
        await existingMed.save(); // Save the medication with the new ords
      } else {
        // New medication - add to box
        await _medicationsBox!.put(medication.id, medication);
      }
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  // Add ord to an existing medication
  Future<void> addOrdToMedication(String medicationId, Ord newOrd) async {
    try {
      if (_medicationsBox == null) {
        throw Exception("Medication box has not been initialized.");
      }

      final medication = _medicationsBox!.get(medicationId);
      if (medication == null) {
        throw Exception('Medication not found');
      }

      // Add the new Ord to the medication's ords list
      medication.ords.add(newOrd);
      await medication.save(); // Save the updated medication with new ord
    } catch (e) {
      throw Exception('Failed to add ord: $e');
    }
  }

  // Fetch all medications
  List<Medication> getAllMedications() {
    if (_medicationsBox == null) {
      throw Exception("Medication box has not been initialized.");
    }

    try {
      return _medicationsBox!.values.toList();
    } catch (e) {
      throw Exception('Failed to fetch medications: $e');
    }
  }

  // Fetch a specific medication by ID
  Future<Medication?> getMedication(String id) async {
    if (_medicationsBox == null) return null;
    return _medicationsBox!.get(id);
  }

  // Delete a medication
  Future<void> deleteMedication(String id) async {
    try {
      if (_medicationsBox == null) {
        throw Exception("Medication box has not been initialized.");
      }

      await _medicationsBox!.delete(id);
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }

  // Close the box (for when you're done with Hive)
  Future<void> close() async {
    await _medicationsBox?.close();
  }
}
