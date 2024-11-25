import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/admin/admin.dart';
import 'package:babyshophub/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:babyshophub/firebase_options.dart';
import 'package:flutter/material.dart';
import 'register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _usernameController.text, // Assuming email is used as username
          password: _passwordController.text,
        );

        // Fetch user details from Firestore
        String userId = userCredential.user!.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (!userDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found in database')),
          );
          return;
        }

        // Get user name and role
        String userName = userDoc['name']; // Get user name from Firestore
        String role =
            userDoc['role'] ?? 'user'; // Default to 'user' if role is not set

        // Navigate to the correct page based on role
        if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdminPage(userName: userName), // Pass userName
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  userPage(userName: userName), // Pass userName
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor:
        appBar: AppBar(
          title: Center(
            child: Image.asset(
              '../assets/2.png',
              fit: BoxFit.contain,
              height: 600,
              width: 60,
            ),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: 250),
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
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                // color: const Color.fromRGBO(
                //     0, 0, 0, 0), // Semi-transparent white background
                color:
                    const Color.fromRGBO(255, 255, 255, 0.822).withOpacity(0.0),

                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 74, 74, 74),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 64, 137, 255)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 64, 137, 255)),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 81, 116, 131),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 64, 137, 255)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 149, 255)),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 81, 116, 131),
                            ),
                            // suffixIcon: Padding(
                            //   padding: EdgeInsets.all(0),
                            //   child: IconButton(onPressed: () {
                            //     setState(() {
                            //      obscureText: !true;
                            //     });
                            //   }, icon: Icon(Icons.remove_red_eye)),
                            // )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  255, 0, 170, 255), // Button color
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              elevation: 5, // Shadow effect
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                            )),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Forgot Password?')),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 74, 74, 74),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const MyRegister()),
                              );
                            },
                            child: const Text("Register your self"))
                      ],
                    ),
                  ),
                ),
              ),
            ))));
  }
}
