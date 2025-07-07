import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // Shortened for performance
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<List<User>> _getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('users');
      if (userData == null) return [];
      final List<dynamic> jsonList = jsonDecode(userData);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      if (mounted) {
        await _showDialog('Error', 'Failed to load users: $e');
      }
      return [];
    }
  }

  Future<void> _saveUsers(List<User> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = users.map((user) => user.toJson()).toList();
      await prefs.setString('users', jsonEncode(jsonList));
    } catch (e) {
      if (mounted) {
        await _showDialog('Error', 'Failed to save user data: $e');
      }
    }
  }

  Future<void> _showDialog(String title, String message) async {
    if (!mounted) return;
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFFF4081)),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      List<User> users = await _getUsers();

      // Check if email already exists
      final emailExists = users.any((user) => user.email == email);
      if (emailExists) {
        await _showDialog('Registration Failed', 'Email already registered');
        setState(() => _isLoading = false);
        return;
      }

      // Create new user
      final newUser = User(
        fullName: fullName,
        email: email,
        password: password,
      );

      users.add(newUser);
      await _saveUsers(users);

      if (!mounted) return;
      await _showDialog('Success', 'Account created successfully!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      await _showDialog('Error', 'An error occurred: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeTitle = isSmallScreen ? 24.0 : 30.0;
    final fontSizeSubtitle = isSmallScreen ? 14.0 : 16.0;
    final fontSizeLabel = isSmallScreen ? 13.0 : 15.0;
    final iconSize = isSmallScreen ? 36.0 : 48.0;
    final buttonHeight = isSmallScreen ? 48.0 : 56.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFFFF4D94).withOpacity(0.9),
              const Color(0xFFFF8AB5).withOpacity(0.85),
              const Color(0xFFFFB8C6).withOpacity(0.8),
              const Color(0xFFFFE4E1),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.25),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: iconSize,
                                color: const Color(0xFFFF4081),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 25),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Column(
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: fontSizeTitle,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                    shadows: [
                                      Shadow(
                                        color: Colors.pink.shade200.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                Text(
                                  'Join the love community',
                                  style: TextStyle(
                                    fontSize: fontSizeSubtitle,
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // Full Name Field with label above
                      _buildInputField(
                        controller: _fullNameController,
                        icon: Icons.person,
                        label: 'Full Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        showLabelAbove: true,
                        labelFontSize: fontSizeLabel,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Email Field with label above
                      _buildInputField(
                        controller: _emailController,
                        icon: Icons.email,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        showLabelAbove: true,
                        labelFontSize: fontSizeLabel,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Password Field with label above
                      _buildInputField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        label: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFFFF4081),
                          ),
                          onPressed: () {
                            if (mounted) {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            }
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        showLabelAbove: true,
                        labelFontSize: fontSizeLabel,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Confirm Password Field with label above
                      _buildInputField(
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline,
                        label: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFFFF4081),
                          ),
                          onPressed: () {
                            if (mounted) {
                              setState(
                                () =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                              );
                            }
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        showLabelAbove: true,
                        labelFontSize: fontSizeLabel,
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 25),

                      SizedBox(
                        width: double.infinity,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4081),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            shadowColor: Colors.pink.withOpacity(0.25),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 8 : 12,
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    height: isSmallScreen ? 18 : 22,
                                    width: isSmallScreen ? 18 : 22,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 15 : 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 13 : 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: isSmallScreen ? 13 : 15,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modified _buildInputField helper:

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool showLabelAbove = false,
    double labelFontSize = 14,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLabelAbove)
                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 6),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: labelFontSize,
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    // no labelText here
                    prefixIcon: Icon(icon, color: const Color(0xFFFF4081)),
                    suffixIcon: suffixIcon,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: isSmallScreen ? 10 : 14,
                    ),
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
