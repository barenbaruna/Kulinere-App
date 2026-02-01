import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/screens/main/main_screen.dart';

/// Animated splash screen with logo and loading indicator.
///
/// Features:
/// - Elastic scale animation for logo
/// - Fade-in for text and loading indicator
/// - Auto-navigation to [MainScreen] after 2.5 seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _controller.forward();
    _scheduleNavigation();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
    );
  }

  void _scheduleNavigation() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mq = MediaQuery.of(context);
    final double logoSize = (mq.size.shortestSide / 2.5).clamp(120.0, 200.0);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.darkBackground,
                    AppColors.darkSurface,
                    AppColors.darkBackground,
                  ]
                : [
                    AppColors.lightBackground,
                    AppColors.lightSurface,
                    AppColors.lightBackground,
                  ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              final spacing = isLandscape ? 16.0 : 32.0;
              final bottomSpacing = isLandscape ? 24.0 : 60.0;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAnimatedLogo(logoSize),
                        SizedBox(height: spacing),
                        _buildAnimatedAppName(isDark),
                        const SizedBox(height: 8),
                        _buildAnimatedTagline(isDark),
                        SizedBox(height: bottomSpacing),
                        _buildLoadingIndicator(isDark),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(double logoSize) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                spreadRadius: 5,
                color: AppColors.gold.withOpacity(0.3),
              ),
              BoxShadow(
                blurRadius: 60,
                spreadRadius: 10,
                color: AppColors.gold.withOpacity(0.1),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset('images/kulinere_logo.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAppName(bool isDark) {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: Text(
        'Kulinere',
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: AppColors.goldVisible(isDark),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline(bool isDark) {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: Text(
        'Where Flavor Lives',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    return FadeTransition(
      opacity: _textFadeAnimation,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.goldVisible(isDark),
          ),
        ),
      ),
    );
  }
}
