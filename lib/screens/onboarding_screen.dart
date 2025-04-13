import 'package:flutter/material.dart';
import 'package:piton_teknoloji/models/model.dart';
import 'home_screen.dart';
import '../widgets/custom_text.dart'; // CustomText widget'ını içe aktar

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: 'assets/onboarding1.png',
      title: 'Keşfet',
      description: 'Favorinizi bulun ve yenilerini keşfedin.',
      backgroundColor: Colors.purple,
    ),
    OnboardingPage(
      image: 'assets/onboarding2.png',
      title: 'Her Yerde Dinle',
      description: 'Podcastleri dinleyin ya da indirin.',
      backgroundColor: Colors.blue,
    ),
    OnboardingPage(
      image: 'assets/onboarding3.png',
      title: 'Güncel Kalın',
      description: 'Yeni bölümler yayınlandığında bildirim alın.',
      backgroundColor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.headphones,
                      size: 120,
                      color: page.backgroundColor,
                    ),
                    const SizedBox(height: 64),
                    CustomText(
                      text: page.title,
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: page.description,
                      color: Colors.grey[400]!,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? _pages[_currentPage].backgroundColor
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Next/Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].backgroundColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: CustomText(
                      text:
                          _currentPage < _pages.length - 1 ? 'İleri' : 'Başla',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
