import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'providers/theme_provider.dart';
import 'screens/chapter_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 Pro dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const ProviderScope(
          child: MyApp(),
        );
      },
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E3D59),
        secondary: const Color(0xFF17C3B2),
        brightness: Brightness.light,
      ).copyWith(
        tertiary: const Color(0xFF4C51C6),
        primary: const Color(0xFF2C5282),
        secondary: const Color(0xFF0891B2),
        surface: Colors.white,
        background: const Color(0xFFF8FAFC),
        surfaceVariant: const Color(0xFFE8F2FF),
        outline: const Color(0xFFCBD5E1),
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(),
      cardTheme: const CardTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E3D59),
        secondary: const Color(0xFF17C3B2),
        brightness: Brightness.dark,
      ).copyWith(
        tertiary: const Color(0xFFFFD93D),
        surface: const Color(0xFF1A1A1A),
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
    );
    
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      data: themeMode == ThemeMode.dark ? darkTheme : lightTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Numerical Analysis',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const SplashScreen(
          nextScreen: OnboardingScreen(nextScreen: HomePage()),
        ),
      ),
    );
  }
  
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  int? selectedChapter;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );
  
  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.6,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
  ));

  late final Animation<double> _rotateAnimation = Tween<double>(
    begin: -0.2,
    end: 0.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
  ));

  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
  ));


  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colorScheme.primary.withOpacity(0.05),
                    colorScheme.surface,
                    colorScheme.secondary.withOpacity(0.05),
                  ]
                : [
                    colorScheme.primary.withOpacity(0.02),
                    colorScheme.background,
                    colorScheme.secondary.withOpacity(0.03),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.2, 0.0),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.tertiary,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'NUMERICAL',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  height: 1.1,
                                  color: Colors.white,
                                ).apply(fontSizeDelta: 2.sp),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'ANALYSIS',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 4,
                                height: 1.1,
                                color: colorScheme.secondary,
                              ).apply(fontSizeDelta: 2.sp),
                            ),
                          ],
                        ),
                        _buildThemeToggle(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'SELECT CHAPTER',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.secondary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ).apply(fontSizeDelta: 1.sp),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_rotateAnimation.value),
                    alignment: Alignment.center,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: [
                            _buildChapterCard(1),
                            _buildChapterCard(2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (selectedChapter != null)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
                    )),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: _buildContinueButton(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final currentTheme = ref.read(themeProvider);
            ref.read(themeProvider.notifier).setTheme(
              currentTheme == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary,
            colorScheme.tertiary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChapterScreen(chapter: selectedChapter!),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CONTINUE TO CHAPTER $selectedChapter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChapterCard(int chapter) {
    final isSelected = selectedChapter == chapter;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 1.0,
        end: isSelected ? 1.05 : 1.0,
      ),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? (isDark ? colorScheme.primary.withOpacity(0.1) : colorScheme.surfaceVariant)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isSelected
                    ? colorScheme.secondary
                    : (isDark ? colorScheme.outline.withOpacity(0.2) : colorScheme.outline),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? colorScheme.secondary.withOpacity(0.2)
                      : colorScheme.primary.withOpacity(0.05),
                  blurRadius: isSelected ? 30 : 20,
                  offset: Offset(0, isSelected ? 10 : 8),
                  spreadRadius: isSelected ? 1 : 0,
                ),
                if (!isDark) BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? (isDark
                        ? [
                            colorScheme.primary.withOpacity(0.15),
                            colorScheme.surface,
                          ]
                        : [
                            colorScheme.surfaceVariant,
                            Colors.white.withOpacity(0.95),
                          ])
                    : [
                        colorScheme.surface,
                        colorScheme.surface,
                      ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: () {
                  setState(() {
                    selectedChapter = selectedChapter == chapter ? null : chapter;
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (isSelected) ...[
                      Positioned(
                        right: -30,
                        bottom: -30,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(
                            begin: 0.0,
                            end: isSelected ? 1.0 : 0.0,
                          ),
                          builder: (context, opacity, _) {
                            return Opacity(
                              opacity: opacity,
                              child: Icon(
                                Icons.circle,
                                size: 120,
                                color: (isDark 
                                    ? colorScheme.secondary
                                    : colorScheme.primary).withOpacity(isDark ? 0.1 : 0.08),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: -20,
                        top: -20,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(
                            begin: 0.0,
                            end: isSelected ? 1.0 : 0.0,
                          ),
                          builder: (context, opacity, _) {
                            return Opacity(
                              opacity: opacity,
                              child: Icon(
                                Icons.circle,
                                size: 80,
                                color: (isDark 
                                    ? colorScheme.tertiary
                                    : colorScheme.secondary).withOpacity(isDark ? 0.08 : 0.1),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chapter.toString(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? colorScheme.primary
                                  : isDark
                                      ? colorScheme.primary.withOpacity(0.8)
                                      : colorScheme.primary.withOpacity(0.8),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'CHAPTER',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: isSelected
                                  ? colorScheme.secondary
                                  : (isDark ? colorScheme.primary.withOpacity(0.7) : colorScheme.primary.withOpacity(0.5)),
                              letterSpacing: 4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
