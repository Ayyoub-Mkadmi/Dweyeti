import 'package:hive/hive.dart';
import '../models/medication.dart';
import '../models/ord.dart';

class MedicationRepository {
  late final Box<Medication> _medicationsBox;

  Future<void> init() async {
    _medicationsBox = await Hive.openBox<Medication>('medications');
  }

  Future<void> addMedication(Medication medication) async {
    try {
      // Check if medication with same name exists
      final existingMed = _medicationsBox.values.firstWhere(
        (m) => m.name.toLowerCase() == medication.name.toLowerCase(),
        orElse:
            () =>
                Medication(id: '', name: '', ords: [], type: '', colorValue: 0),
      );

      if (existingMed.id.isNotEmpty) {
        // Medication exists - add new ORD to it
        existingMed.ords.addAll(medication.ords);
        await existingMed.save();
      } else {
        // New medication - add to box
        await _medicationsBox.put(medication.id, medication);
      }
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  Future<void> addOrdToMedication(String medicationId, Ord newOrd) async {
    try {
      final medication = _medicationsBox.get(medicationId);
      if (medication == null) {
        throw Exception('Medication not found');
      }

      medication.ords.add(newOrd);
      await medication.save();
    } catch (e) {
      throw Exception('Failed to add ord: $e');
    }
  }

  List<Medication> getAllMedications() {
    try {
      return _medicationsBox.values.toList();
    } catch (e) {
      throw Exception('Failed to fetch medications: $e');
    }
  }

  Future<Medication?> getMedication(String id) async {
    return _medicationsBox.get(id);
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _medicationsBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }

  Future<void> close() async {
    await _medicationsBox.close();
  }
}
