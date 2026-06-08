import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.pink.withOpacity(0.4), width: 2),
                  ),
                  child: const Center(child: Text('🎟', style: TextStyle(fontSize: 38))),
                ),
                const SizedBox(height: 16),
                const Text('ShowPass', style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 6),
                const Text('YOUR PREMIUM TICKET APP', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 3)),
                const SizedBox(height: 48),
                _DotIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DotIndicator extends StatefulWidget {
  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final active = i == (_ctrl.value * 3).floor() % 3;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: active ? AppColors.purple : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        },
      )),
    );
  }
}
