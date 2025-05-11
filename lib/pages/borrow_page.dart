import 'package:app_sisfo/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:app_sisfo/components/appbar.dart';
import 'package:app_sisfo/models/borrowModel.dart';
import 'package:app_sisfo/pages/returnForm_page.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({Key? key}) : super(key: key);

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  final UserService _userService = UserService();
  List<dynamic> _borrows = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBorrows();
  }

  Future<void> _fetchBorrows() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _userService.getBorrow();

      if (response.containsKey('error')) {
        setState(() {
          _errorMessage = response['error'];
        });
      } else {
        setState(() {
          _borrows = response['data'] ?? [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load borrows: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithDrawer(
      title: 'Borrow',
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_borrows.isEmpty) {
      return const Center(child: Text('No borrow records found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _borrows.length,
      itemBuilder: (context, index) {
        final borrow = _borrows[index];
        return _buildBorrowCard(borrow);
      },
    );
  }

  Widget _buildBorrowCard(Map<String, dynamic> borrow) {
    final borrowModel = Borrow.fromMap(borrow);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to ReturnFormPage when card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReturnFormPage(
                userId: borrowModel.userId, // Assuming Borrow model has userId
                borrowId: borrowModel.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Borrow ID: ${borrowModel.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Item ID: ${borrowModel.itemId}'),
              Text('Quantity: ${borrowModel.quantity}'),
              Text('Borrow Date: ${borrowModel.borrowDate}'),
              Text('Purposes: ${borrowModel.purposes}'),
              Text('Status: ${borrowModel.status}'),
              Text(
                'Approved: ${borrow['is_approved'] == 1 ? 'Yes' : 'No'}',
                style: TextStyle(
                  color: borrow['is_approved'] == 1 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
