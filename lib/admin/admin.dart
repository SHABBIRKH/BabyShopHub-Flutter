import 'package:flutter/material.dart';
import 'drawer.dart';

class AdminPage extends StatelessWidget {
  final String userName;

  const AdminPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
        ),
        drawer: sidebar(userName: userName),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 250, 218, 221),
                Color.fromARGB(255, 197, 234, 248),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.admin_panel_settings,
                    size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                Text(
                  'Welcome, Admin $userName',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(255, 74, 74, 74),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
