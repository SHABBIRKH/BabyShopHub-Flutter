import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyRegister extends StatelessWidget {
  const MyRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;
  final String? _role = 'User'; // Default role is User

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Register the user with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the user object
        User? user = userCredential.user;

        // Store the user data in Firestore
        await _firestore.collection('users').doc(user?.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'gender': _gender,
          'role': _role, // Storing the role (Admin/User)
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful')));

        // Navigate to home page or login screen
        // Example: Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Add ScrollView here
        child: Container(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Get the screen size
                  double screenWidth = constraints.maxWidth;
                  double screenHeight = constraints.maxHeight;

                  // Define responsive font size and padding
                  double fontSize = screenWidth < 400 ? 18 : 20;
                  double padding = screenWidth < 400 ? 12 : 16;

                  return Card(
                    color: Colors.white
                        .withOpacity(0.8), // Semi-transparent white background
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: fontSize +
                                    12, // Adjusting font size for larger screens
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 74, 74, 74),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextFormField(
                              controller: _nameController,
                              label: 'Name',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextFormField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextFormField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextFormField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextFormField(
                              controller: _addressController,
                              label: 'Address',
                              icon: Icons.home,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildGenderDropdown(),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 202, 177),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth < 400 ? 12 : 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: fontSize, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Navigating to Login...')),
                                );
                              },
                              child: const Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  // color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 81, 116, 131),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _gender = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }
}
