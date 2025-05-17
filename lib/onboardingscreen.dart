import 'package:flutter/material.dart';
import 'startscreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Color> backgroundColors = [
    Color(0xFFF8FEFF), // Very light teal
    Color(0xFFE9F6F9), // Light teal
    Color(0xFFDBEBEE), // Soft teal blue
  ];

//TODO: the images needs to be changed
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Organization",
      "text":
      "Simplify today, master tomorrow. Organize your tasks, set your goals, and bring balance to your daily routine—one step at a time.",
      "image":
      "assets/info1.jpg"
    },
    {
      "title": "Reminders",
      "text":
      "A gentle reminder that it’s time to turn plans into action. Your next task is ready when you are.",
      "image":
      "assets/info2.jpg"
    },
    {
      "title": "Schedules",
      "text":
      "A schedule that fits your life—not the other way around. Tailored to your preferences, making every day more manageable.",
      "image":
      "assets/info3.jpg"
    },
  ];

  void nextPageOrNavigate() {
    if (currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TitleScreen()),
      );
    }
  }

  void goBackPage() {
    if (currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (_, index) {
              return Container(
                color: backgroundColors[index],


                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: currentPage == index ? 1.0 : 0.0,
                          child: Image.asset(
                            onboardingData[index]["image"]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.3),
                              end: Offset.zero,
                            ).animate(animation),
                            child:
                            FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Text(
                          onboardingData[index]["title"]!,
                          key: ValueKey(onboardingData[index]["title"]),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.4),
                              end: Offset.zero,
                            ).animate(animation),
                            child:
                            FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Text(
                          onboardingData[index]["text"]!,
                          key: ValueKey(onboardingData[index]["text"]),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                              (dotIndex) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage == dotIndex ? 20 : 12,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentPage == dotIndex
                                  ? Colors.teal.shade700
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: nextPageOrNavigate,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFF004D40),
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Visibility(
              visible: currentPage > 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: goBackPage,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}