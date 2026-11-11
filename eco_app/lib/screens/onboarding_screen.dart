import 'package:flutter/material.dart';

import '../services/session_manager.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.public,
      title: 'Together for a\nGreener Planet',
      description:
          'Welcome to Eco App! Join us in creating a cleaner, '
          'healthier, and more sustainable world.',
      color: const Color(0xFF168A55),
      backgroundIcon: Icons.eco,
    ),
    _OnboardingPage(
      icon: Icons.report_problem_outlined,
      title: 'Report Environmental\nProblems',
      description:
          'Report garbage accumulation, pollution, and other '
          'environmental issues in your neighbourhood.',
      color: const Color(0xFF238B57),
      backgroundIcon: Icons.location_on_outlined,
    ),
    _OnboardingPage(
      icon: Icons.track_changes,
      title: 'Track Your\nComplaints',
      description:
          'Keep track of your submitted complaints and check '
          'their status whenever you need.',
      color: const Color(0xFF147D4E),
      backgroundIcon: Icons.fact_check_outlined,
    ),
    _OnboardingPage(
      icon: Icons.volunteer_activism_outlined,
      title: 'Be the Change\nOur Planet Needs',
      description:
          'Every report is a step towards a cleaner community. '
          'Start making a difference today!',
      color: const Color(0xFF0B5D3B),
      backgroundIcon: Icons.forest_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      _openWelcomeOptions();
    }
  }

  void _skipPages() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _openWelcomeOptions() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const WelcomeOptionsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF5),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.eco,
                    color: Color(0xFF168A55),
                    size: 29,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Eco App',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF124B32),
                    ),
                  ),
                  const Spacer(),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipPages,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF168A55),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Animated introduction pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });

                  _animationController
                    ..reset()
                    ..forward();
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Illustration area
                            Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.color.withValues(
                                  alpha: 0.09,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 190,
                                    height: 190,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.color.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 145,
                                    height: 145,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.color,
                                      boxShadow: [
                                        BoxShadow(
                                          color: item.color.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 24,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      item.icon,
                                      size: 75,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: 24,
                                    right: 35,
                                    child: Icon(
                                      Icons.eco,
                                      color: item.color,
                                      size: 35,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 28,
                                    left: 30,
                                    child: Icon(
                                      item.backgroundIcon,
                                      color: item.color,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 42),

                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 29,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF123D2B),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15.5,
                                height: 1.7,
                                color: Color(0xFF65766B),
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

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  width: _currentPage == index ? 27 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _currentPage == index
                        ? const Color(0xFF168A55)
                        : const Color(0xFFD5E4D8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Navigation button
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF168A55),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for onboarding pages
class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final IconData backgroundIcon;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.backgroundIcon,
  });
}

// Welcome screen with registration, login and guest access
class WelcomeOptionsScreen extends StatelessWidget {
  const WelcomeOptionsScreen({super.key});

  // Start a guest session and navigate to Home Screen
  Future<void> _continueAsGuest(BuildContext context) async {
    try {
      await SessionManager.startGuestSession();

      if (!context.mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to continue as guest: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Eco App logo
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFF168A55),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF168A55).withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 75,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'A Greener Tomorrow\nStarts With You',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123D2B),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Join your community in reporting environmental '
                  'problems and working towards a cleaner world.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Color(0xFF65766B),
                  ),
                ),

                const SizedBox(height: 40),

                // Create Account button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF168A55),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF168A55),
                      side: const BorderSide(
                        color: Color(0xFF168A55),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'I Already Have an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Continue as Guest button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _continueAsGuest(context),
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF168A55),
                      side: const BorderSide(
                        color: Color(0xFFB7D8C3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Explore Eco App without creating an account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF65766B),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'REPORT  •  PROTECT  •  IMPROVE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF168A55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
