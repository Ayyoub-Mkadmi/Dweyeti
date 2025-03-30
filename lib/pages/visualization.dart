import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/models/medication.dart';
import '../data/models/ord.dart';

class HiveViewerPage extends StatelessWidget {
  const HiveViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final medicationsBox = Hive.box<Medication>('medications');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force rebuild to refresh data
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medicationsBox.length,
        itemBuilder: (context, index) {
          final medication = medicationsBox.getAt(index);
          if (medication == null) return const SizedBox();

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medication ${index + 1}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('ID:', medication.id),
                  _buildInfoRow('Name:', medication.name),
                  _buildInfoRow('Type:', medication.type),
                  _buildInfoRow(
                    'Color:',
                    Color(medication.colorValue).toString(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Treatment Periods (Ords):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...medication.ords.map((ord) => _buildOrdCard(ord)).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Hive.box('medications').clear();
          (context as Element).markNeedsBuild();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Database cleared')));
        },
        tooltip: 'Clear Database',
        child: const Icon(Icons.delete),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildOrdCard(Ord ord) {
    return Card(
      margin: const EdgeInsets.only(top: 8.0),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Ord ID:', ord.idOrd),
            _buildInfoRow('Frequency:', ord.frequency),
            _buildInfoRow('Times:', ord.times.join(', ')),
            _buildInfoRow('Notes:', ord.notes),
            const SizedBox(height: 8),
            const Text(
              'History:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (ord.history.isEmpty)
              const Text('No history available')
            else
              ...ord.history.map(
                (entry) => Text(
                  '- ${entry.toString()}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
