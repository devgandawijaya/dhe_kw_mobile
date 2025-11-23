import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 80),

                // Logo Dotcom
                Image.asset(
                  'assets/dhe.png',
                  height: 200,
                ),

                const SizedBox(height: 30),

                // Email / Phone Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Username/nip',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password Field
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: _toggleVisibility,
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            height: 100,
                            child: const Center(
                              child: Text(
                                'menu ini sedang dalam development',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Forgot Your Password?',
                      style: TextStyle(
                        color: Color(0xFF00796B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ),
                ),

                const SizedBox(height: 30),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Or Login with
                const Text(
                  'Or Login with',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 25),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(
                      Icons.facebook,
                      const Color(0xFF3b5998),
                      () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 100,
                              child: const Center(
                                child: Text(
                                  'menu ini sedang dalam development',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 25),
                    _socialIcon(
                      Icons.mail_outline,
                      const Color(0xFF34A853),
                      () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 100,
                              child: const Center(
                                child: Text(
                                  'menu ini sedang dalam development',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ), // Google style
                    const SizedBox(width: 25),
                    _socialIcon(
                      Icons.apple,
                      Colors.black,
                      () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 100,
                              child: const Center(
                                child: Text(
                                  'menu ini sedang dalam development',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
            ),

            const SizedBox(height: 30),

            // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(20.0),
                                height: 100,
                                child: const Center(
                                  child: Text(
                                    'menu ini sedang dalam development',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xFF00796B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
