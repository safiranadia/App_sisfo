import 'package:flutter/material.dart';
import 'package:app_sisfo/services/userService.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final UserService _userService = UserService();

  List<dynamic> _returns = [];
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReturnData();
  }

  Future<void> _fetchReturnData() async {
    final response = await _userService.getReturn();

    if (response.containsKey('error')) {
      setState(() {
        _errorMessage = response['error'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _returns = response['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Pengembalian")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : ListView.builder(
                    itemCount: _returns.length,
                    itemBuilder: (context, index) {
                      final item = _returns[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text("Pengembalian ID: ${item['id']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tanggal Kembali: ${item['return_date']}"),
                              Text("Kondisi: ${item['condition']}"),
                              Text("Catatan: ${item['note']}"),
                              Text("Status: ${item['status']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
