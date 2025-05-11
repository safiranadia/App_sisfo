import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_sisfo/services/userService.dart';

class BorrowFormPage extends StatefulWidget {
  final int userId;
  final int itemId;

  const BorrowFormPage({
    super.key,
    required this.userId,
    required this.itemId,
  });

  @override
  State<BorrowFormPage> createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _borrowDateController = TextEditingController();
  final TextEditingController _purposesController = TextEditingController();
  int _quantity = 1;
  bool _isSubmitting = false;

  final UserService _userService = UserService();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final data = {
      "user_id": widget.userId,
      "item_id": widget.itemId,
      "borrow_date": _borrowDateController.text,
      "quantity": _quantity,
      "purposes": _purposesController.text,
    };

    final response = await _userService.submitBorrow(data);

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['error']}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Peminjaman berhasil dikirim")),
      );
      Navigator.pop(context);
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Peminjaman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _borrowDateController,
                readOnly: true,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Peminjaman'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    _borrowDateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal peminjaman wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _purposesController,
                decoration:
                    const InputDecoration(labelText: 'Tujuan Peminjaman'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Jumlah Peminjaman'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _quantity = int.tryParse(value) ?? 0;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Jumlah peminjaman wajib diisi'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
