import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class EquipmentEditPage extends StatefulWidget {
  final String token;
  final Map data;

  const EquipmentEditPage({super.key, required this.token, required this.data});

  @override
  State<EquipmentEditPage> createState() => _EquipmentEditPageState();
}

class _EquipmentEditPageState extends State<EquipmentEditPage> {
  late TextEditingController name;
  late TextEditingController tag;
  late TextEditingController tanggal;

  late String kondisi;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data['name']);
    tag = TextEditingController(text: widget.data['tag_number'].toString());
    tanggal = TextEditingController(text: widget.data['tanggal_masuk_aset']);
    kondisi = widget.data['kondisi'] ?? "baik";
  }

  Future submit() async {
    await ApiService.updateEquipment(widget.data['id'], {
      "name": name.text,
      "tag_number": int.parse(tag.text),
      "tanggal_masuk_aset": tanggal.text,
      "kondisi": kondisi,
    }, widget.token);

    if (!mounted) return;
    Navigator.pop(context);
  }

  // 🔥 STYLE INPUT
  InputDecoration style(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // 🔥 DATE PICKER
  Future pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggal.text = picked.toString().split(" ")[0]; // format YYYY-MM-DD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Edit Equipment"),
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [

              // 🔥 NAME
              TextField(
                controller: name,
                decoration: style("Nama Equipment"),
              ),
              const SizedBox(height: 12),

              // 🔥 TAG
              TextField(
                controller: tag,
                keyboardType: TextInputType.number,
                decoration: style("Tag Number"),
              ),
              const SizedBox(height: 12),

              // 🔥 DATE PICKER
              TextField(
                controller: tanggal,
                readOnly: true,
                decoration: style("Tanggal Masuk Aset").copyWith(
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: pickDate,
              ),
              const SizedBox(height: 12),

              // 🔥 DROPDOWN KONDISI
              DropdownButtonFormField<String>(
                value: kondisi,
                decoration: style("Kondisi"),
                items: const [
                  DropdownMenuItem(value: "baik", child: Text("Baik")),
                  DropdownMenuItem(value: "rusak", child: Text("Rusak")),
                ],
                onChanged: (val) => setState(() => kondisi = val!),
              ),

              const SizedBox(height: 20),

              // 🔥 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Data",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}