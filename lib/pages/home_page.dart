import 'package:flutter/material.dart';
import 'package:app_sisfo/components/appbar.dart';
import 'package:app_sisfo/services/userService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _returnResponse = {};
  Map<String, dynamic> _borrowResponse = {};

  @override
  void initState() {
    super.initState();
    _getReturnCount();
    _getBorrowCount();
  }

  Future<void> _getReturnCount() async {
    final response = await UserService().getReturnCount();
    setState(() {
      _returnResponse = response;
    });
  }

  Future<void> _getBorrowCount() async {
    final response = await UserService().getBorrowCount();
    setState(() {
      _borrowResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithDrawer(
      title: 'Home',
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF87CEFA)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'HALO, USER!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                _buildDashboardCard(
                  title: 'Peminjaman Barang',
                  value: _borrowResponse.containsKey('error')
                      ? 'Error'
                      : '${_borrowResponse['data'] ?? 0}',
                ),
                const SizedBox(height: 24),
                _buildDashboardCard(
                  title: 'Pengembalian Barang',
                  value: _returnResponse.containsKey('error')
                      ? 'Error'
                      : '${_returnResponse['data'] ?? 0}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({required String title, required String value}) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
