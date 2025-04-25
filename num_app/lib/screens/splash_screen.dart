import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller for entrance
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Pulse animation that runs continuously
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Background animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutQuad),
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1, 
    ).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _mainController.forward().then((_) async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOutCubic;

                var fadeAnimation = Tween(
                  begin: begin,
                  end: end,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  ),
                );

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        colorScheme.surface.withOpacity(0.9),
                        colorScheme.surface,
                        colorScheme.primary.withOpacity(0.05 + 0.03 * _backgroundAnimation.value),
                      ]
                    : [
                        colorScheme.background.withOpacity(0.97),
                        colorScheme.background,
                        colorScheme.primary.withOpacity(0.03 + 0.02 * _backgroundAnimation.value),
                      ],
                stops: [0.0, 0.6 - 0.1 * _backgroundAnimation.value, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(8, (index) {
                  final random = math.Random(index);
                  final size = random.nextDouble() * 20 + 10;
                  final xPosition = random.nextDouble() * MediaQuery.of(context).size.width;
                  final yPosition = random.nextDouble() * MediaQuery.of(context).size.height;
                  final opacity = random.nextDouble() * 0.1;
                  final color = index % 2 == 0 ? colorScheme.primary : colorScheme.secondary;
                  final animationOffset = random.nextDouble();
                  
                  return Positioned(
                    left: xPosition,
                    top: yPosition + 30 * math.sin((_backgroundAnimation.value + animationOffset) * 2 * math.pi),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
                
                // Main content
                Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_mainController, _pulseController]),
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Transform.scale(
                            scale: _pulseAnimation.value,
                            child: SvgPicture.asset(
                              'assets/bt2.svg',
                              width: size.width * 0.85,
                              height: size.height * 0.5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 