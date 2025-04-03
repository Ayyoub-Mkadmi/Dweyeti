import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/models/medication.dart';
import '../data/models/ord.dart';
import '../data/models/history.dart'; // Make sure you import the History model

class HiveViewerPage extends StatelessWidget {
  const HiveViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final medicationsBox = Hive.box<Medication>('medications');
    final historyBox = Hive.box<History>('history'); // Open the history box

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
                    'Treatment Periods:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...medication.ords
                      .map((ord) => _buildOrdCard(ord, historyBox))
                      .toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await medicationsBox.clear();
          await historyBox.clear(); // Clear the history box as well
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

  Widget _buildOrdCard(Ord ord, Box<History> historyBox) {
    final duration = ord.endDate.difference(ord.startDate).inDays;

    return Card(
      margin: const EdgeInsets.only(top: 8.0),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Ord ID:', ord.idOrd),
            _buildInfoRow('Start Date:', _formatDate(ord.startDate)),
            _buildInfoRow('End Date:', _formatDate(ord.endDate)),
            _buildInfoRow('Duration:', '$duration days'),
            _buildInfoRow('Times:', ord.times.join(', ')),
            _buildInfoRow('Notes:', ord.notes),
            const SizedBox(height: 8),
            const Text(
              'History:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // FutureBuilder to load history data for this ord
            FutureBuilder<List<History>>(
              future: _getHistoryForOrd(ord.idOrd, historyBox),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No history available');
                } else {
                  return Column(
                    children:
                        snapshot.data!
                            .map(
                              (history) => Text(
                                '- ${history.status} at ${_formatDate(history.date)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fetch history for the given ordId
  Future<List<History>> _getHistoryForOrd(
    String ordId,
    Box<History> historyBox,
  ) async {
    final List<History> historyList = [];
    for (int i = 0; i < historyBox.length; i++) {
      final history = historyBox.getAt(i);
      if (history != null && history.ordId == ordId) {
        historyList.add(history);
      }
    }
    return historyList;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
