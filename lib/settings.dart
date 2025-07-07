import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  User? _currentUser;
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCurrentUser();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _fullNameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString('users');
      final email = prefs.getString('current_user_email');

      if (usersData != null && email != null) {
        final List<User> users =
            (jsonDecode(usersData) as List<dynamic>)
                .map((u) => User.fromJson(u))
                .toList();
        final user = users.firstWhere(
          (u) => u.email == email,
          orElse: () => User(fullName: '', email: '', password: ''),
        );
        if (user.email.isNotEmpty) {
          if (mounted) {
            setState(() {
              _currentUser = user;
              _fullNameController.text = user.fullName;
              _passwordController.text = user.password;
            });
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('User not found')));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No user logged in')));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading user: $e')));
      }
    }
  }

  Future<void> _updateUser() async {
    if (_currentUser == null) return;

    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (fullName.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be at least 2 characters')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString('users');
      final email = prefs.getString('current_user_email');

      if (usersData != null && email != null) {
        List<User> users =
            (jsonDecode(usersData) as List<dynamic>)
                .map((u) => User.fromJson(u))
                .toList();
        final index = users.indexWhere((u) => u.email == email);

        if (index != -1) {
          users[index] = User(
            fullName: fullName,
            email: email,
            password: password,
          );
          await prefs.setString(
            'users',
            jsonEncode(users.map((u) => u.toJson()).toList()),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_email');

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeTitle = isSmallScreen ? 22.0 : 28.0;
    final fontSizeLabel = isSmallScreen ? 13.0 : 15.0;
    final fontSizeText = isSmallScreen ? 14.0 : 16.0;
    final buttonHeight = isSmallScreen ? 48.0 : 56.0;

    if (_currentUser == null) {
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
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF4081)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFFF4081),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.pink.withOpacity(0.3),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: fontSizeTitle,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.8,
                            shadows: [
                              Shadow(
                                color: Colors.pink.shade200.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // Full Name Label + Input
                  Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSizeLabel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
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
                          child: TextField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFFFF4081),
                              ),
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
                            style: TextStyle(fontSize: fontSizeText),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Email Label + ReadOnly Input
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSizeLabel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
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
                          child: TextField(
                            controller: TextEditingController(
                              text: _currentUser!.email,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xFFFF4081),
                              ),
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
                            style: TextStyle(fontSize: fontSizeText),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Password Label + Input
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSizeLabel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
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
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFFFF4081),
                              ),
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
                            style: TextStyle(fontSize: fontSizeText),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Save Button
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _updateUser,
                            icon: const Icon(Icons.save, size: 20),
                            label: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 15 : 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Logout Button
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _logout,
                            icon: const Icon(Icons.logout, size: 20),
                            label: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 15 : 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              shadowColor: Colors.red.withOpacity(0.25),
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
