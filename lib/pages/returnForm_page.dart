import 'package:app_sisfo/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repositories/token_repository.dart';
import '../models/borrowModel.dart';

class ReturnFormPage extends StatefulWidget {
  @override
  _ReturnFormPageState createState() => _ReturnFormPageState();
}

class _ReturnFormPageState extends State<ReturnFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TokenRepository _tokenRepo = TokenRepository();

  String? _selectedCondition;
  String? _selectedStatus;
  Borrow? _selectedBorrow;

  List<Borrow> _borrowList = [];
  bool _isLoadingBorrow = true;

  @override
  void initState() {
    super.initState();
    _fetchBorrows();
  }

  Future<void> _fetchBorrows() async {
    final borrows = await _userService.getBorrow();
    setState(() {
      _borrowList = borrows;
      _isLoadingBorrow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoadingBorrow
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<Borrow>(
                        decoration: const InputDecoration(
                          labelText: 'Borrow ID',
                        ),
                        value: _selectedBorrow,
                        onChanged: (Borrow? newValue) {
                          setState(() {
                            _selectedBorrow = newValue;
                          });
                        },
                        items: _borrowList
                            .map((borrow) => DropdownMenuItem<Borrow>(
                                  value: borrow,
                                  child: Text(
                                      'ID: ${borrow.id} - ${borrow.item?.name ?? "Unknown"}'),
                                ))
                            .toList(),
                        validator: (value) =>
                            value == null ? 'Borrow ID is required' : null,
                      ),
                      TextFormField(
                        controller: _returnDateController,
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Return Date'),
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
                            value!.isEmpty ? 'Return date is required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Condition'),
                        value: _selectedCondition,
                        onChanged: (value) {
                          setState(() {
                            _selectedCondition = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Condition is required' : null,
                        items: ['good', 'bad', 'lost']
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Status'),
                        value: _selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Status is required' : null,
                        items: ['finish', 'finish(bad)', 'finish(lost)']
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                ))
                            .toList(),
                      ),
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(labelText: 'Note'),
                        maxLength: 500,
                        maxLines: null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final userId = await _tokenRepo.getUserId();

                            final data = {
                              'user_id': userId,
                              'borrow_id': _selectedBorrow!.id,
                              'return_date': _returnDateController.text,
                              'condition': _selectedCondition,
                              'note': _noteController.text,
                              'status': _selectedStatus,
                            };

                            final response =
                                await _userService.submitReturn(data);

                            if (response.containsKey('error')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Error: ${response['error']}")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Return submitted successfully")),
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
      ),
    );
  }
}
