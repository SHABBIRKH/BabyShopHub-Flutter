import 'package:flutter/material.dart';

class userPage extends StatelessWidget {
  final String userName;

  // Constructor to accept userName as a named parameter
  const userPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('user Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings,
                size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Welcome, user $userName',
              style: const TextStyle(
                fontSize: 32,
                color: Color.fromARGB(255, 74, 74, 74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
