import 'package:flutter/material.dart';
import 'package:babyshophub/admin/admin.dart';
import 'category.dart';
class sidebar extends StatelessWidget {
  final String userName; 
  const sidebar({super.key, required this.userName});
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 CircleAvatar(
                  radius: 30,
                  // backgroundColor: Colors.white,
                  child: Image.asset('../assets/logo.png',fit: BoxFit.cover,),
                ),
                const SizedBox(height: 10),
                Text(
                  userName, // Display the userName dynamically
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            onTap: () {
              Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPage(userName: userName),
      ),
    );
            },
          ),
          ListTile(
            title: const Text('Categories'),
            leading: const Icon(Icons.category),
            onTap: () {
              Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyCategoryApp(), // Pass userName
          ),
        );
            },
          ),
          ListTile(
            title: const Text('Products'),
            leading: const Icon(Icons.shopping_bag),
            onTap: () {
            
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
            
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}