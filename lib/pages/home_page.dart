import 'package:flutter/material.dart';
import 'package:app_sisfo/components/appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarWithDrawer(
      title: 'Home',
      body: Center(
        child: Text('Welcome to the Home Page'),
      ),
    );
  }
}
