import 'package:flutter/material.dart';

class MedicineCard extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MedicineCard({required this.controller, this.onChanged, Key? key})
    : super(key: key);

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  final List<String> medicines = [
    "Paracetamol",
    "Ibuprofen",
    "Aspirin",
    "Amoxicillin",
    "Cetirizine",
    "Metformin",
    "Omeprazole",
    "Losartan",
  ];

  List<String> filteredMedicines = [];

  void _showMedicinePicker() {
    TextEditingController customController = TextEditingController();
    setState(() {
      filteredMedicines = medicines;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextField(
                            controller: customController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 76, 201, 240),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 76, 201, 240),
                                  width: 2.0,
                                ),
                              ),
                              hintText: "أدخل اسم الدواء...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            onChanged: (value) {
                              setModalState(() {
                                filteredMedicines =
                                    medicines
                                        .where(
                                          (med) => med.toLowerCase().contains(
                                            value.toLowerCase(),
                                          ),
                                        )
                                        .toList();
                              });
                            },
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                widget.controller.text = value;
                                widget.onChanged?.call(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: filteredMedicines.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(filteredMedicines[index]),
                                  onTap: () {
                                    widget.controller.text =
                                        filteredMedicines[index];
                                    widget.onChanged?.call(
                                      filteredMedicines[index],
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

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
                  ": اسم الدواء",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 76, 201, 240),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget.controller,
                textAlign: TextAlign.right,
                readOnly: true,
                onTap: _showMedicinePicker,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.medical_services,
                    color: Color.fromARGB(255, 76, 201, 240),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 76, 201, 240),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 76, 201, 240),
                      width: 2.0,
                    ),
                  ),
                  hintText: "ادخل اسم الدواء أو اختر من القائمة",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
