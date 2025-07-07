import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'home.dart';
import 'user.dart';
import 'dart:convert';
import 'login.dart';

class ResultPage extends StatefulWidget {
  final String name1;
  final String name2;
  final String gender1;
  final String gender2;
  final int percent;

  const ResultPage({
    super.key,
    required this.name1,
    required this.name2,
    required this.gender1,
    required this.gender2,
    required this.percent,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  int _displayedPercent = 0;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animatePercent();
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

  void _animatePercent() {
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_displayedPercent < widget.percent) {
        setState(() {
          _displayedPercent++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _generateMessage(int percent) {
    switch (percent) {
      case 100:
        return "Absolutely perfect! Your souls are intertwined in a way that defies explanation. This is a once-in-a-lifetime connection where every moment together feels like magic. Cherish this rare and beautiful bond that promises forever happiness. 💖✨";
      case 99:
        return "Near perfection! You complement each other so well that it feels like destiny itself brought you together. Every little detail about your relationship shines with love, trust, and understanding. A true fairy tale in the making. 🌟💫";
      case 98:
        return "Almost flawless! Your connection radiates warmth and deep affection. Challenges may arise, but your strong foundation and mutual respect will see you through anything. Together, you’re unstoppable. ❤️‍🔥";
      case 97:
        return "Extremely compatible! You have an amazing balance of passion, respect, and shared dreams. Your love story is inspiring and full of potential to grow stronger every day. Keep nurturing it! 🌹";
      case 96:
        return "So close to perfect! Your relationship feels natural and effortless, like you’ve known each other forever. Together you create harmony and joy that others admire. This is a beautiful journey you’re on. 💞";
      case 95:
        return "Exceptional bond! Your mutual support and emotional connection create a powerful partnership. You both bring out the best in each other and build a future full of hope and happiness. 🌈";
      case 94:
        return "Almost ideal! Your chemistry is electric, and your shared values keep your love grounded. Together, you inspire one another to grow and chase your dreams side by side. 💫";
      case 93:
        return "Very strong match! Your relationship is full of kindness, patience, and joy. You communicate well and genuinely care about each other's well-being, creating a beautiful dynamic. 💖";
      case 92:
        return "Wonderful connection! There is a deep understanding between you that few are lucky to find. You share laughter, secrets, and dreams, making every moment special. Keep building on this amazing bond. 🌟";
      case 91:
        return "Remarkable love! Your relationship is passionate yet stable, full of respect and shared goals. Together, you’re creating a solid foundation for a bright future. Keep cherishing this rare gem. 💍";
      case 90:
        return "You're a perfect match made in heaven. Your love feels destined and natural, filled with moments of joy and deep connection. Challenges only make you stronger as a couple. Treasure this beautiful union. 💘";
      case 89:
        return "Your relationship sparkles with genuine affection and mutual respect. Together, you create a warm and loving environment where both feel safe and valued. This connection has great potential to blossom. 🌹";
      case 88:
        return "Strong chemistry and heartfelt emotions define your bond. You support each other's dreams and bring happiness into each other's lives in a way that feels truly special. Keep nurturing this beautiful connection. 🔥";
      case 87:
        return "You share a lovely mix of excitement and comfort. Your compatibility shines in your shared laughter, thoughtful gestures, and genuine care. This relationship has a promising future if you keep investing in it. 💕";
      case 86:
        return "A wonderful match with lots of potential. Your connection is marked by honest communication and mutual admiration. With patience and love, you can overcome any obstacle that comes your way. 💞";
      case 85:
        return "Your bond is full of warmth, kindness, and fun moments together. You balance each other well and enjoy the journey as much as the destination. This relationship has a strong foundation to grow upon. 🌟";
      case 84:
        return "You bring out the best in each other and share a deep respect for one another’s individuality. This is a relationship where love and friendship blend beautifully. Keep cherishing every moment. ❤️";
      case 83:
        return "A very compatible couple with a lot of love to give. Your shared values and dreams help you move forward as a team. Keep communicating openly and supporting one another to build something lasting. 🌈";
      case 82:
        return "Strong potential for a lasting relationship. You complement each other’s personalities and bring joy into everyday life. With continued effort and love, your bond will only deepen. 💫";
      case 81:
        return "Your relationship shines with a mix of affection and understanding. You make each other feel special and supported, creating a lovely partnership full of promise. Keep nurturing your connection! 💖";
      case 80:
        return "Strong chemistry! Keep the flame alive by staying open, honest, and supportive. Your love has the power to overcome challenges and blossom into something truly beautiful. 🔥";
      case 79:
        return "Your connection is filled with warmth and kindness. While there may be occasional bumps, your shared commitment and care for each other make the journey worthwhile. Together, you can grow stronger. 💕";
      case 78:
        return "You have a wonderful blend of passion and friendship. Your ability to laugh together and support each other forms a solid base for a loving relationship. Keep building on this great foundation. 💞";
      case 77:
        return "A couple with plenty of affection and respect. Your relationship flourishes when you communicate honestly and make time for one another. There's real potential here to blossom. 🌹";
      case 76:
        return "Your bond is warm and supportive, offering comfort in times of stress. By nurturing your emotional connection, you’ll create a relationship that’s resilient and joyful. Keep going strong! 💓";
      case 75:
        return "You two really click! The laughter, shared dreams, and caring gestures create a delightful partnership. Keep investing in each other to turn potential into lasting happiness. 💘";
      case 74:
        return "Your relationship has many strengths, including mutual respect and kindness. It may require some patience and effort, but the rewards will be well worth it. Keep believing in your connection. 🌟";
      case 73:
        return "A promising connection with plenty of affection and understanding. By openly sharing your thoughts and feelings, you can deepen your bond and overcome any obstacles together. 💞";
      case 72:
        return "You bring out each other's best qualities and enjoy many joyful moments together. Challenges might arise, but your commitment and love will guide you through. Keep nurturing this relationship. ❤️";
      case 71:
        return "Your relationship is filled with laughter and mutual support. Stay open to growth and change, and your connection can continue to flourish beautifully. You’re on a great path! 🌈";
      case 70:
        return "You two really click! Your friendship forms the heart of this relationship, and with love and care, it has the power to blossom into something truly special. Keep nurturing your bond. 💘";
      case 69:
        return "A connection that’s growing stronger each day. While not perfect, your shared experiences and understanding build a solid foundation. Keep communicating and supporting each other. 💓";
      case 68:
        return "Your relationship is full of promise, with genuine affection and kindness. With a little patience and effort, you can overcome challenges and strengthen your bond. Keep believing in each other. 💞";
      case 67:
        return "You share a meaningful connection that’s worth investing in. Stay honest, patient, and loving, and your relationship will continue to grow in depth and happiness. 🌟";
      case 66:
        return "Good vibes all around! Your caring nature and shared goals create a solid base. Keep nurturing your love, and your relationship can blossom into something truly beautiful. 💕";
      case 65:
        return "A nice mix of affection and friendship. Your bond has room to grow with open communication and mutual respect. Don’t be afraid to show your feelings and support each other. 💞";
      case 64:
        return "Your relationship has many strengths, but may require patience and understanding at times. Keep investing in each other and you’ll build a lasting and rewarding partnership. ❤️";
      case 63:
        return "You have a solid connection with lots of potential. Embrace your differences and communicate openly to grow even closer. With time and effort, this relationship can thrive. 🌹";
      case 62:
        return "Your bond is warm and supportive, with plenty of care and kindness. Keep nurturing your emotional connection to overcome any bumps along the way. Together, you can flourish. 💫";
      case 61:
        return "A growing connection filled with caring moments and shared dreams. Continue being patient and understanding, and your relationship will grow deeper and stronger. 💖";
      case 60:
        return "Good vibes all around! Worth exploring further as you both bring positive energy and support. With honest communication and care, this relationship can truly blossom. 💕";
      case 59:
        return "Your relationship shows promise, but may have some areas that need attention. Stay open, patient, and understanding to work through any challenges together. 💞";
      case 58:
        return "A connection with potential if both are willing to grow and learn together. Keep sharing your feelings and supporting each other to deepen your bond. 🌟";
      case 57:
        return "Your relationship has moments of warmth and joy, but also challenges. Focus on honest communication and empathy to build a stronger connection. ❤️";
      case 56:
        return "A caring couple with lots of potential. By nurturing understanding and patience, you can create a loving and fulfilling relationship. Keep investing in each other. 💓";
      case 55:
        return "Your connection is worth working on, with moments of affection and shared dreams. Stay open and honest to keep the relationship moving forward. 💞";
      case 54:
        return "You have some strong points as a couple, but may face challenges. With mutual effort and kindness, you can grow closer and build trust. 🌈";
      case 53:
        return "Your bond shows promise if you both commit to understanding and patience. Open communication will be key to overcoming obstacles. 💖";
      case 52:
        return "There's potential here, keep it going by supporting and valuing each other. The journey may have bumps, but love and effort can conquer them. 💞";
      case 51:
        return "A relationship with possibility. Stay patient and communicate your feelings openly to build a more stable and loving connection. ❤️";
      case 50:
        return "There's potential here, keep it going. This relationship can flourish with care, honesty, and mutual respect. Don’t lose hope. 💞";
      case 49:
        return "A bit of a rocky road ahead, but with effort and understanding, you can build a stronger relationship. Keep an open mind and heart. ⚡️";
      case 48:
        return "The relationship has some challenges, but with patience and honest communication, there is hope to grow closer and build trust. 💫";
      case 47:
        return "Some ups and downs, but if you both commit to understanding each other better, this relationship can improve and become more rewarding. 💓";
      case 46:
        return "It’s a bit rocky but could work with effort and patience. Focus on listening and empathizing to create a stronger bond. ⚡️";
      case 45:
        return "Challenges exist, but shared respect and willingness to grow can help you overcome difficulties. Keep working on communication and trust. 💞";
      case 44:
        return "The connection faces obstacles, but with kindness and perseverance, you can work through them and find common ground. ⚡️";
      case 43:
        return "Some sparks here, but the relationship requires honest effort and understanding to flourish. Stay patient and open-hearted. 💓";
      case 42:
        return "It's a bit rocky but worth the effort if you both commit to growing together. Communication and empathy will be your allies. ⚡️";
      case 41:
        return "The relationship needs care and attention. With patience and mutual respect, you can overcome challenges and find harmony. 💞";
      case 40:
        return "It's a bit rocky but could work with effort. Open your hearts and minds to truly understand each other better. ⚡️";
      case 39:
        return "Hmm... some sparks, but needs work to turn into a fulfilling connection. Patience and honest communication are key. 😅";
      case 38:
        return "Your relationship has moments of warmth but also uncertainty. Focusing on open dialogue and empathy can help smooth rough edges. 💬";
      case 37:
        return "There are flashes of affection, but misunderstandings may be frequent. Work on listening and expressing yourselves clearly to grow closer. 💞";
      case 36:
        return "Sparks exist but are fragile. With patience and honest effort, you can build trust and deepen your bond. Don’t give up easily. 😅";
      case 35:
        return "Some sparks, but needs work. Your relationship will require open hearts and lots of patience to reach its potential. 😅";
      case 34:
        return "This relationship has ups and downs, and it will take effort to maintain harmony. Honest communication is essential. 💬";
      case 33:
        return "Sparks are faint and fragile here. To make this work, both must be willing to understand and support each other through difficulties. 😓";
      case 32:
        return "The connection is uncertain and will need careful nurturing. Patience and openness can help grow understanding. 😅";
      case 31:
        return "Sparks exist but are inconsistent. Honest communication and a willingness to work on issues can improve things. Don’t lose hope yet. 😅";
      case 30:
        return "Hmm... some sparks, but needs work. Your relationship is a challenge that requires commitment and honest effort to develop further. 😅";
      case 29:
        return "Not the easiest match. Differences may cause friction, but if you both try to understand and respect each other, it’s not impossible. 💡";
      case 28:
        return "Challenges abound, but with patience and genuine effort, you might find common ground and create a meaningful connection. 💡";
      case 27:
        return "This match is difficult, but with honest communication and a willingness to grow, you can overcome obstacles. Keep an open mind. 💡";
      case 26:
        return "There’s potential if both are willing to put in serious effort, communicate openly, and respect each other’s differences. 💡";
      case 25:
        return "A challenging relationship that requires understanding and patience. It may not be easy, but growth is possible with commitment. 💡";
      case 24:
        return "Difficulties are many, but with honest hearts and mutual respect, you might find a way to make this work. It takes effort from both sides. 💡";
      case 23:
        return "Not a simple match, and misunderstandings may be common. If you’re both willing to listen and adjust, there’s a chance for growth. 💡";
      case 22:
        return "This relationship will test your patience and understanding. Don’t give up too quickly; some bonds need time and effort to bloom. 💡";
      case 21:
        return "It’s a tough match, but with open communication and willingness to adapt, you can build some understanding. It won’t be easy though. 💡";
      case 20:
        return "Not the easiest match, but don't give up yet. Sometimes, opposites challenge us to grow in unexpected ways. Approach with an open heart. 💡";
      case 19:
        return "This connection is difficult and will require a lot of patience and effort. Growth is possible if you both commit, but it won’t be effortless. 🤔";
      case 18:
        return "Challenges and misunderstandings may dominate this relationship. However, with honest effort, you could discover hidden depths worth exploring. 🤔";
      case 17:
        return "Not a natural fit, but sometimes the toughest matches teach us the most. Keep communication honest and open if you want to try. 🤔";
      case 16:
        return "This relationship faces many obstacles, and it will require more than average effort to succeed. Are you both ready for the challenge? 🤔";
      case 15:
        return "A difficult match with many bumps along the road. Only genuine commitment and love can make a difference here. Be prepared for hard work. 🤔";
      case 14:
        return "Opposites may attract... or not. This relationship might be a rollercoaster, requiring patience and understanding to navigate. 🤨";
      case 13:
        return "A challenging connection where differences might overshadow the positives. If you both want it to work, communication and compromise are crucial. 🤨";
      case 12:
        return "This match will test your resilience and patience. It may bring valuable lessons, even if it doesn’t last forever. Approach with caution. 🤨";
      case 11:
        return "The relationship has more hurdles than harmony. Only with serious effort and honest communication can it improve, but it will be tough. 🤨";
      case 10:
        return "Opposites may attract... or not. This relationship might feel like a constant push and pull, so proceed with realistic expectations. 😬";
      case 9:
        return "There’s very little common ground here, and misunderstandings might be frequent. It could be more frustrating than fulfilling. Be mindful of your feelings. 😕";
      case 8:
        return "A difficult match that might leave both feeling misunderstood or disconnected. If you want to continue, be prepared for many compromises. 😕";
      case 7:
        return "Challenges dominate this relationship, and it may cause more stress than joy. Reflect carefully on whether it’s worth pursuing. 😕";
      case 6:
        return "This connection struggles with communication and compatibility. It might be best to consider if your energies are better spent elsewhere. 🤷‍♂️";
      case 5:
        return "Very little harmony here; you may feel more frustrated than fulfilled. It could be wise to rethink this relationship’s potential. 🤷‍♂️";
      case 4:
        return "A relationship that feels more challenging than rewarding. If you’re both willing to try, be prepared for significant effort and possible disappointment. 🤷‍♂️";
      case 3:
        return "The odds aren’t in your favor here. Misunderstandings and clashes might dominate, so be cautious and honest with yourself. 🤷‍♂️";
      case 2:
        return "This connection is likely to cause frustration and confusion. It might be best to focus on friendship rather than romance. 🤷‍♂️";
      case 1:
        return "Better luck next time! Maybe just friends? Sometimes, two people simply don’t match romantically, but friendship can still be beautiful. 🤷‍♂️";
      default:
        return "Love is a journey full of surprises—keep your heart open and cherish the connections you make.";
    }
  }

  void _shareResult() {
    final msg =
        "${widget.name1} (${widget.gender1}) ❤️ ${widget.name2} (${widget.gender2})\nLove Compatibility: ${widget.percent}%\n${_generateMessage(widget.percent)}";
    Share.share(msg);
  }

  Future<User?> _getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserEmail = prefs.getString('current_user_email');
      if (currentUserEmail == null) return null;

      final userData = prefs.getString('users');
      if (userData == null) return null;

      final List<dynamic> jsonList = jsonDecode(userData);
      final users = jsonList.map((json) => User.fromJson(json)).toList();

      return users.firstWhere((u) => u.email == currentUserEmail);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching user: $e")));
      }
      return null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeTitle = isSmallScreen ? 22.0 : 28.0;
    final fontSizeText = isSmallScreen ? 14.0 : 16.0;
    final buttonHeight = isSmallScreen ? 48.0 : 56.0;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: size.height,
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
          child: Column(
            children: [
              // Top App Title or Custom Back Button
              Padding(
                padding: EdgeInsets.only(top: padding, left: padding),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Love Test Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Text(
                              "${widget.name1} (${widget.gender1}) ❤️ ${widget.name2} (${widget.gender2})",
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
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: isSmallScreen ? 120 : 150,
                                  height: isSmallScreen ? 120 : 150,
                                  child: CircularProgressIndicator(
                                    value: _displayedPercent / 100,
                                    strokeWidth: isSmallScreen ? 8 : 10,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.3,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFFF4081),
                                        ),
                                  ),
                                ),
                                Text(
                                  '$_displayedPercent%',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 28 : 34,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Text(
                              _generateMessage(widget.percent),
                              style: TextStyle(
                                fontSize: fontSizeText,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Wrap(
                              spacing: isSmallScreen ? 10 : 15,
                              runSpacing: isSmallScreen ? 10 : 15,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Saved (not implemented)",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.bookmark, size: 20),
                                  label: const Text('Save'),
                                  style: _buttonStyle(isSmallScreen),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _shareResult,
                                  icon: const Icon(Icons.share, size: 20),
                                  label: const Text('Share'),
                                  style: _buttonStyle(isSmallScreen),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (!mounted) return;
                                    final user = await _getCurrentUser();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                user != null
                                                    ? Home(user: user)
                                                    : const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.refresh, size: 20),
                                  label: const Text('Try Again'),
                                  style: _buttonStyle(isSmallScreen),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(bool isSmallScreen) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF4081),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.pink.withOpacity(0.25),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 10,
      ),
    );
  }
}
