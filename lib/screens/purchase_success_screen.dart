import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/shared_widgets.dart';
import '../models/ticket_model.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  final PurchasedTicket ticket;
  const PurchaseSuccessScreen({super.key, required this.ticket});

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tk = widget.ticket;
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 100, height: 100,
                  decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.check, color: Colors.white, size: 52)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Compra realizada!', style: TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Seu ingresso está pronto. Divirta-se!', style: TextStyle(color: AppColors.textMuted, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 32),

              // Summary card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Text(tk.event.imageEmoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(tk.event.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(tk.event.name, style: const TextStyle(color: AppColors.textMuted, fontSize: 12), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoPill(label: 'TIPO', value: tk.ticketType.name),
                        _InfoPill(label: 'QTD', value: '${tk.quantity}x'),
                        _InfoPill(label: 'ASSENTO', value: tk.seatCode),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total pago', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        Text('R\$ ${tk.totalPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.purple, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),
              PrimaryButton(
                label: 'Ver meu ingresso',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
                  // Navigate to tickets tab
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pushNamed(context, AppRoutes.myTickets);
                  });
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false),
                child: const Text('Voltar para o início', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label, value;
  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
