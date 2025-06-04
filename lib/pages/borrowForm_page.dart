import 'package:app_sisfo/models/itemModel.dart';
import 'package:app_sisfo/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_sisfo/services/userService.dart';

class BorrowFormPage extends StatefulWidget {
  @override
  State<BorrowFormPage> createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _borrowDateController = TextEditingController();
  final TextEditingController _purposesController = TextEditingController();
  int _quantity = 1;
  bool _isSubmitting = false;
  List<ItemModel> _items = [];
  ItemModel? _selectedItem;
  bool _isLoadingItems = true;

  final UserService _userService = UserService();
  final TokenRepository _tokenRepo = TokenRepository();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final userId = await _tokenRepo.getUserId();

    final data = {
      "user_id": userId,
      "item_id": _selectedItem?.id,
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

  Future<void> _loadItems() async {
    final items = await _userService.getItems();

    setState(() {
      _items = items;
      _isLoadingItems = false;
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
              _isLoadingItems
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<ItemModel>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Item',
                      ),
                      value: _selectedItem,
                      items: _items.map((item) {
                        return DropdownMenuItem<ItemModel>(
                          value: item,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Item wajib dipilih' : null,
                    ),
              const SizedBox(height: 12),
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
