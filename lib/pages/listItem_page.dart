import 'package:app_sisfo/pages/borrowForm_page.dart';
import 'package:flutter/material.dart';
import 'package:app_sisfo/components/appbar.dart';
import 'package:app_sisfo/models/itemModel.dart';
import 'package:app_sisfo/services/userService.dart';
import 'package:app_sisfo/repositories/token_repository.dart';

class ListItemPage extends StatefulWidget {
  const ListItemPage({Key? key}) : super(key: key);

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  final UserService _userService = UserService();
  final TokenRepository _tokenRepo = TokenRepository();
  List<ItemModel> _items = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _userService.getItems();

    if (response.containsKey('error')) {
      setState(() {
        _errorMessage = response['error'];
        _isLoading = false;
      });
    } else {
      final List<dynamic> data = response['data'];
      setState(() {
        _items = data.map((e) => ItemModel.fromMap(e)).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithDrawer(
      title: 'List Item',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          'http://192.168.1.10:8000/storage/img/${item.image}',
                          width: 50,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                            'Stock: ${item.stock} | Lokasi: ${item.location}'),
                        onTap: () async {
                          final userId = await _tokenRepo.getUserId();

                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please log in first')),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BorrowFormPage(
                                  userId: userId,
                                  itemId: item.id,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
