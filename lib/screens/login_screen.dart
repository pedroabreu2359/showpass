import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'lucas@email.com');
  final _passCtrl = TextEditingController(text: '••••••••');
  bool _loading = false;
  bool _obscure = true;

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    AppState().login('Lucas Ferreira', _emailCtrl.text);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _loginWith(String provider) async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    AppState().login('Lucas Ferreira', 'lucas@${provider.toLowerCase()}.com');
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              width: double.infinity,
              color: AppColors.bgMid,
              child: Stack(
                children: [
                  const Positioned(right: -20, top: -20,
                    child: Text('🎵', style: TextStyle(fontSize: 120, color: Colors.white10)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(8)),
                            child: const Center(child: Text('🎟', style: TextStyle(fontSize: 16)))),
                          const SizedBox(width: 8),
                          const Text('ShowPass', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                        ]),
                        const SizedBox(height: 12),
                        const Text('Bem-vindo! 👋', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        const Text('Entre para descobrir os melhores eventos', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _Field(label: 'E-MAIL', controller: _emailCtrl, hint: 'seu@email.com', icon: Icons.email_outlined),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'SENHA', controller: _passCtrl, hint: '••••••••',
                    icon: Icons.lock_outline, obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textMuted, size: 18),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Esqueceu a senha?', style: TextStyle(color: AppColors.pink, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(label: 'Entrar', onTap: _login, isLoading: _loading),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou continue com', style: TextStyle(color: AppColors.textMuted, fontSize: 11))),
                    Expanded(child: Divider(color: AppColors.border)),
                  ]),
                  const SizedBox(height: 16),
                  _SocialButton(label: 'Entrar com Google', emoji: 'G', color: Colors.white, textColor: Colors.black, onTap: () => _loginWith('Google')),
                  const SizedBox(height: 10),
                  _SocialButton(label: 'Entrar com Apple', emoji: '🍎', color: Colors.black, textColor: Colors.white, onTap: () => _loginWith('Apple')),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Não tem conta? ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                      child: const Text('Criar conta', style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _Field({required this.label, required this.controller, required this.hint, required this.icon, this.obscure = false, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label, emoji;
  final Color color, textColor;
  final VoidCallback onTap;

  const _SocialButton({required this.label, required this.emoji, required this.color, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          backgroundColor: AppColors.bgSurface,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(emoji, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w800))),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ]),
      ),
    );
  }
}
