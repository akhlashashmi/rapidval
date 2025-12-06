import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/services/local_storage/hive_storage_service.dart';

class OnboardingPageData {
  final String title;
  final String highlight; // Part of the title to color differently
  final String description;
  final IconData icon;

  OnboardingPageData({
    required this.title,
    required this.highlight,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // UPDATED COPYWRITING
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Evaluate at the\n',
      highlight: 'Speed of Thought',
      description:
          'Instantly test your knowledge on any topic—from Quantum Physics to Ancient History. Learning, reimagined.',
      icon: FontAwesomeIcons.bolt,
    ),
    OnboardingPageData(
      title: 'Powered by\n',
      highlight: 'Adaptive AI',
      description:
          'Our engine evolves with you. It generates personalized quizzes that target your weak spots and accelerate growth.',
      icon: FontAwesomeIcons.brain,
    ),
    OnboardingPageData(
      title: 'Visualize Your\n',
      highlight: 'Journey to Mastery',
      description:
          'Turn data into confidence. Track deep analytics to identify gaps and visualize your rapid improvement.',
      icon: FontAwesomeIcons.chartPie,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    HapticFeedback.mediumImpact();
    await ref
        .read(localStorageServiceProvider)
        .put('settings', 'onboarding_seen', true);
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // 1. Ambient Animated Background
          const _AmbientBackground(),

          // 2. Main Page Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildPageContent(
                      context,
                      _pages[index],
                      index == _currentPage,
                    );
                  },
                ),
              ),

              // Spacing for the bottom fixed area
              SizedBox(height: size.height * 0.22),
            ],
          ),

          // 3. Skip Button (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentPage == _pages.length - 1 ? 0.0 : 1.0,
              child: TextButton(
                onPressed: _currentPage == _pages.length - 1
                    ? null
                    : _finishOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withOpacity(0.6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),

          // 4. Bottom Controls (Indicators + Big Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface.withOpacity(0),
                    colorScheme.surface.withOpacity(0.9),
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.3, 0.6],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: isActive ? 32 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // THE BIG ACTION BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child:
                        FilledButton(
                              onPressed: _onNext,
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                elevation: 10,
                                shadowColor: colorScheme.primary.withOpacity(
                                  0.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) =>
                                    FadeTransition(
                                      opacity: anim,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.2),
                                          end: Offset.zero,
                                        ).animate(anim),
                                        child: child,
                                      ),
                                    ),
                                child: _currentPage == _pages.length - 1
                                    ? Row(
                                        key: const ValueKey('Start'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Get Started',
                                            style: GoogleFonts.outfit(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            FontAwesomeIcons.rocket,
                                            size: 18,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        key: const ValueKey('Next'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Continue',
                                            style: GoogleFonts.outfit(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            FontAwesomeIcons.arrowRight,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            )
                            .animate(
                              target: _currentPage == _pages.length - 1 ? 1 : 0,
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Colors.white24,
                              delay: 500.ms,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    OnboardingPageData page,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),

          // RICH HERO VISUAL
          _GlassHero(icon: page.icon, isActive: isActive),

          const Spacer(flex: 2),

          // TEXT CONTENT
          RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: colorScheme.onSurface,
                    height: 1.1,
                  ),
                  children: [
                    TextSpan(text: page.title),
                    TextSpan(
                      text: page.highlight,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: colorScheme
                            .primary, // Could also use a gradient shader here
                      ),
                    ),
                  ],
                ),
              )
              .animate(key: ValueKey(page.title))
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .moveY(
                begin: 20,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad,
              ),

          const SizedBox(height: 24),

          Text(
                page.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              )
              .animate(key: ValueKey(page.description))
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .moveY(
                begin: 20,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad,
              ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER WIDGETS FOR VISUAL FLAIR
// -----------------------------------------------------------------------------

class _GlassHero extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _GlassHero({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 320,
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Back Glow
          Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 2500.ms,
              ),

          // 2. Abstract Geometric Shapes (Rotating)
          ...List.generate(3, (index) {
            return Transform.rotate(
                  angle: index * 1.0,
                  child: Container(
                    width: 260 - (index * 40),
                    height: 260 - (index * 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: colorScheme.onSurface.withOpacity(
                          0.05 + (index * 0.02),
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat())
                .rotate(
                  duration: (10 + index * 5).seconds,
                  curve: Curves.linear,
                );
          }),

          // 3. Frosted Glass Card
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(icon, size: 70, color: colorScheme.primary)
                      .animate(target: isActive ? 1 : 0)
                      .scale(duration: 400.ms, curve: Curves.elasticOut)
                      .then()
                      .shimmer(
                        duration: 1500.ms,
                        color: Colors.white.withOpacity(0.5),
                      ),
                ),
              ),
            ),
          ),

          // 4. Floating Elements
          Positioned(
            top: 40,
            right: 40,
            child: _FloatingDot(delay: 0, color: colorScheme.tertiary),
          ),
          Positioned(
            bottom: 60,
            left: 50,
            child: _FloatingDot(delay: 1000, color: colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}

class _FloatingDot extends StatelessWidget {
  final int delay;
  final Color color;

  const _FloatingDot({required this.delay, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -20,
          duration: 2000.ms,
          delay: delay.ms,
          curve: Curves.easeInOut,
        );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Very subtle moving gradients
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child:
              Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colorScheme.primaryContainer.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 5.seconds,
                  ),
        ),
        Positioned(
          bottom: -50,
          left: -100,
          child:
              Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colorScheme.secondaryContainer.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(begin: 0, end: 50, duration: 6.seconds),
        ),

        // A subtle blur overlay to smooth everything out
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: const SizedBox.expand(),
        ),
      ],
    );
  }
}
