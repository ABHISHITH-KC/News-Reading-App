import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function to handle the login process
  void _handleLogin(Function loginMethod) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await loginMethod();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add a logo or welcome message at the top
                  Icon(Icons.lock, size: 100, color: Colors.blueAccent),
                  SizedBox(height: 30),

                  // Email Text Field
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Password Text Field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 25),

                  // Login Button with Gradient Effect
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                    ),
                    onPressed: () => _handleLogin(() => AuthService.loginWithEmailPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    )),
                    child: Text('Login with Email/Password', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: 20),

                  // Google Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Google color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                    ),
                    onPressed: () => _handleLogin(AuthService.loginWithGoogle),
                    child: Text('Login with Google', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: 20),

                  // Anonymous Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Anonymous color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                    ),
                    onPressed: () => _handleLogin(AuthService.loginAnonymously),
                    child: Text('Login Anonymously', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
    );
  }
}
