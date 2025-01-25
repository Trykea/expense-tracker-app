import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/screen/expense_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  late var _isLogin = true;

  Future<void> _login() async {
    try {
      if (_isLogin) {
        // Handle login
        final response = await ApiService.login(
          _usernameController.text,
          _passwordController.text,
        );
        final token = response['token'];
        print('Token: $token');
      } else {
        // Handle signup
        final response = await ApiService.signup(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
        final token =
            response['token']; // Ensure this matches the backend response
        print('Token: $token');
      }

      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExpenseScreen(),
        ),
      );
    } catch (e) {
      print('Error: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Login or Signup')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                  width: 200,
                  child: Image.asset('assets/images/Sample_User_Icon.png')),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (!_isLogin)
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          _isLogin ? 'Log in' : 'Sign up',
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Don\'t have an account? Sign Up'
                              : 'Already have an account? Login')),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
