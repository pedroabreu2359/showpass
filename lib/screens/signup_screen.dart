import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  void _signup() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    AppState().login(_nameCtrl.text, _emailCtrl.text);
    Navigator.pushReplacementNamed(context, AppRoutes.musicTaste);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: AppColors.bgMid,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8),
                    const Text('Criar conta 🎉', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                    const Text('Junte-se a milhares de fãs', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildField('NOME COMPLETO', _nameCtrl, 'Seu nome', Icons.person_outline),
                  const SizedBox(height: 12),
                  _buildField('E-MAIL', _emailCtrl, 'seu@email.com', Icons.email_outlined),
                  const SizedBox(height: 12),
                  _buildField('SENHA', _passCtrl, '••••••••', Icons.lock_outline, obscure: _obscure),
                  const SizedBox(height: 12),
                  _buildField('CONFIRMAR SENHA', _confirmCtrl, '••••••••', Icons.lock_outline, obscure: _obscure),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Criar conta', onTap: _signup, isLoading: _loading),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Já tem conta? ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Fazer login', style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w700, fontSize: 13)),
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

  Widget _buildField(String label, TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}
