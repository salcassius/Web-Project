import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/user.dart';
import 'result.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final name1Controller = TextEditingController();
  final name2Controller = TextEditingController();
  String? gender1 = 'Male';
  String? gender2 = 'Male';

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late AnimationController _percentAnimationController;
  late Animation<double> _percentAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _percentAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _percentAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _percentAnimationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _percentAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _percentAnimationController.forward();
      }
    });

    if (mounted) {
      _animationController.forward();
      _percentAnimationController.forward();
    }
  }

  @override
  void dispose() {
    name1Controller.dispose();
    name2Controller.dispose();
    _animationController.dispose();
    _percentAnimationController.dispose();
    super.dispose();
  }

  void _startTest() {
    final name1 = name1Controller.text.trim();
    final name2 = name2Controller.text.trim();

    if (name1.isEmpty || name2.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter both names")));
      return;
    }

    if (gender1 == null || gender2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select genders for both names")),
      );
      return;
    }

    final random = Random();
    final percent = random.nextInt(101);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResultPage(
                name1: name1,
                name2: name2,
                gender1: gender1!,
                gender2: gender2!,
                percent: percent,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final padding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeTitle = isSmallScreen ? 24.0 : 30.0;
    final fontSizeText = isSmallScreen ? 14.0 : 16.0;
    final iconSize = isSmallScreen ? 40.0 : 50.0;
    final heartBoxHeight = iconSize + 30;
    final buttonHeight = isSmallScreen ? 50.0 : 60.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Love Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              }
            },
          ),
        ],
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(padding, 80.0, padding, padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        "Match Couple Relationship",
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0,
                          shadows: [
                            Shadow(
                              color: Colors.pink.shade300.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: isSmallScreen ? 32 : 48),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    _buildNameInput(
                                      controller: name1Controller,
                                      hint: 'Boy Friend',
                                      isSmallScreen: isSmallScreen,
                                      fontSizeText: fontSizeText,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildGenderSwitch(
                                      value: gender1,
                                      onChanged:
                                          (val) =>
                                              setState(() => gender1 = val),
                                      fontSizeText: fontSizeText,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: iconSize + 30,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: const Color(0xFFFF4081),
                                      size: iconSize,
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedBuilder(
                                      animation: _percentAnimationController,
                                      builder: (context, _) {
                                        final percent =
                                            _percentAnimation.value.toInt();
                                        return Text(
                                          '$percent%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSizeText + 3,
                                            shadows: [
                                              Shadow(
                                                color: Colors.pink.shade300
                                                    .withOpacity(0.7),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    _buildNameInput(
                                      controller: name2Controller,
                                      hint: 'Girl Friend',
                                      isSmallScreen: isSmallScreen,
                                      fontSizeText: fontSizeText,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildGenderSwitch(
                                      value: gender2,
                                      onChanged:
                                          (val) =>
                                              setState(() => gender2 = val),
                                      fontSizeText: fontSizeText,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: isSmallScreen ? 32 : 48),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: SizedBox(
                        width: double.infinity,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: _startTest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4081),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 6,
                            shadowColor: Colors.pink.withOpacity(0.4),
                          ),
                          child: Text(
                            'Enter',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
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
    );
  }

  Widget _buildNameInput({
    required TextEditingController controller,
    required String hint,
    required bool isSmallScreen,
    required double fontSizeText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.person, color: Color(0xFFFF4081)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isSmallScreen ? 12 : 16,
          ),
          hintStyle: TextStyle(
            fontSize: fontSizeText,
            color: Colors.grey.shade600,
          ),
        ),
        style: TextStyle(
          fontSize: fontSizeText,
          color: const Color(0xFFFF4081),
        ),
      ),
    );
  }

  Widget _buildGenderSwitch({
    required String? value,
    required void Function(String?) onChanged,
    required double fontSizeText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: value == 'Female',
          onChanged: (bool isFemale) {
            onChanged(isFemale ? 'Female' : 'Male');
          },
          activeColor: const Color(0xFFFF4081),
          activeTrackColor: const Color(0xFFFF4D94).withOpacity(0.9),
          inactiveThumbColor: const Color(0xFFFF8AB5).withOpacity(0.85),
          inactiveTrackColor: const Color(0xFFFFB8C6).withOpacity(0.8),
        ),
        Text(
          value == 'Female' ? 'Female' : 'Male',
          style: TextStyle(
            fontSize: fontSizeText,
            color: const Color(0xFFFF4081),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
