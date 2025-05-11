import 'package:app_sisfo/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReturnFormPage extends StatefulWidget {
  final int userId;
  final int borrowId;

  const ReturnFormPage({
    Key? key,
    required this.userId,
    required this.borrowId,
  }) : super(key: key);

  @override
  _ReturnFormPageState createState() => _ReturnFormPageState();
}

class _ReturnFormPageState extends State<ReturnFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCondition;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'User ID',
                ),
                initialValue: widget.userId.toString(),
                enabled: false,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Borrow ID',
                ),
                initialValue: widget.borrowId.toString(),
                enabled: false,
              ),
              TextFormField(
                controller: _returnDateController,
                readOnly: true,
                decoration:
                    const InputDecoration(labelText: 'Tanggal Pengembalian'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    _returnDateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal pengembalian wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Condition',
                ),
                value: _selectedCondition,
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Condition is required';
                  }
                  return null;
                },
                items: ['good', 'bad', 'lost']
                    .map((condition) => DropdownMenuItem<String>(
                          value: condition,
                          child: Text(condition),
                        ))
                    .toList(),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status is required';
                  }
                  return null;
                },
                items: ['finish', 'finish(bad)', 'finish(lost)']
                    .map((status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Note',
                ),
                controller: _noteController,
                maxLength: 500,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (value.length > 500) {
                    return 'Note is too long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final data = {
                      'user_id': widget.userId,
                      'borrow_id': widget.borrowId,
                      'return_date': _returnDateController.text,
                      'condition': _selectedCondition,
                      'note': _noteController.text,
                      'status': _selectedStatus,
                    };

                    final response = await _userService.submitReturn(data);

                    if (response.containsKey('error')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${response['error']}")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Return submitted successfully")),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
