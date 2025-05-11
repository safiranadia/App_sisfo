// appbar_with_drawer.dart
import 'package:app_sisfo/pages/borrow_page.dart';
import 'package:app_sisfo/pages/home_page.dart';
import 'package:app_sisfo/pages/listItem_page.dart';
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
              color: Colors.blue,
            ),
            child: Text('Menu Header'),
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
        ],
      ),
    );
  }
}
