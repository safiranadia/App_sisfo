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
  List<Borrow> _borrows = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBorrows();
  }

  Future<void> _fetchBorrows() async {
    try {
      final borrows = await _userService.getBorrow();

      setState(() {
        _borrows = borrows;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch borrows: $e';
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

  Widget _buildBorrowCard(Borrow borrow) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Detail Borrow ${borrow.id}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item ID: ${borrow.itemId}'),
                      Text('Quantity: ${borrow.quantity}'),
                      Text('Borrow Date: ${borrow.borrowDate}'),
                      Text('Purposes: ${borrow.purposes}'),
                      Text('Status: ${borrow.status}'),
                      Text(
                        'Approved: ${borrow.isApproved == 1 ? 'Yes' : 'No'}',
                        style: TextStyle(
                          color: borrow.isApproved == 1
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Borrow ID: ${borrow.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Item Name: ${borrow.item?.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ]),
          )),
    );
  }
}
