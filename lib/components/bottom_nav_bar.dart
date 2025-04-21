import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/components/choose_med.dart';
import 'package:test/data/repositories/medication_repository.dart';
import 'package:test/pages/home_page.dart';
import 'package:test/pages/medical_page.dart';
import 'package:test/pages/pill_page.dart';
import 'package:test/pages/sachet_page.dart';
import 'package:test/pages/syringe_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late final MedicationRepository _repository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = Provider.of<MedicationRepository>(context);
  }

  final List<Widget> _pages = [HomePage(), HomeScreen(), MedicalPage()];

  void _showMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 217, 238, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "اختار دواك",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ChooseMed(
                    med: 'حربوشة',
                    imagePath: "assets/tile/Rectangle3.png",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PillPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ChooseMed(
                    med: 'شكاير',
                    imagePath: "assets/tile/Rectangle1.png",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SachetPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ChooseMed(
                    med: 'زريقة',
                    imagePath: "assets/tile/Rectangle2.png",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SyringePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _showMedicineDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4CC9F0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information),
            label: 'Medical',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home Page"));
  }
}
