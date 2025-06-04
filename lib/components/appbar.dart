import 'package:app_sisfo/pages/borrowForm_page.dart';
import 'package:app_sisfo/pages/borrow_page.dart';
import 'package:app_sisfo/pages/home_page.dart';
import 'package:app_sisfo/pages/listItem_page.dart';
import 'package:app_sisfo/pages/login_page.dart';
import 'package:app_sisfo/pages/report_page.dart';
import 'package:app_sisfo/pages/returnForm_page.dart';
import 'package:app_sisfo/repositories/token_repository.dart';
import 'package:flutter/material.dart';

class AppBarWithDrawer extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget body;

  const AppBarWithDrawer({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
        actions: actions,
      ),
      drawer: _buildDrawer(context),
      body: body,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Image(
              image: AssetImage('assets/img/logoSisfo.png'),
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          ),
          ListTile(
            title: const Text('List Item'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ListItemPage();
              }));
            },
          ),
          ListTile(
            title: const Text('Borrow'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BorrowPage();
              }));
            },
          ),
          ListTile(
            title: const Text('Form Borrow'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BorrowFormPage();
              }));
            },
          ),
          ListTile(
            title: const Text('Report'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ReportPage();
              }));
            },
          ),
          ListTile(
            title: const Text('Form Report'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ReturnFormPage();
              }));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              final _tokenRepo = TokenRepository();
              await _tokenRepo.deleteToken();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
