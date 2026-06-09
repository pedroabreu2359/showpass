import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import '../models/event_model.dart';

class PaymentScreen extends StatefulWidget {
  final EventModel event;
  final TicketType ticketType;
  final int quantity;

  const PaymentScreen({super.key, required this.event, required this.ticketType, required this.quantity});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _method = 0;
  bool _loading = false;

  double get _subtotal => widget.ticketType.price * widget.quantity;
  double get _fee => _subtotal * 0.05;
  double get _total => _subtotal + _fee;

  static const _methods = [
    {'name': 'Pix', 'sub': 'Aprovação instantânea', 'icon': 'Pix', 'color': 0xFF00B4AB},
    {'name': 'Cartão de crédito', 'sub': 'Até 6x sem juros', 'icon': '💳', 'color': 0xFF9333EA},
    {'name': 'Apple Pay', 'sub': 'Pagamento rápido', 'icon': '🍎', 'color': 0xFFFFFFFF},
    {'name': 'Google Pay', 'sub': 'Pagamento rápido', 'icon': 'G', 'color': 0xFF4285F4},
  ];

  void _pay() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final ticket = AppState().purchaseTicket(
      event: widget.event,
      ticketType: widget.ticketType,
      quantity: widget.quantity,
    );
    Navigator.pushReplacementNamed(context, AppRoutes.purchaseSuccess, arguments: ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgMid,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pagamento', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RESUMO DO PEDIDO', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  _SummaryRow('${widget.quantity}x ${widget.ticketType.name} — ${widget.event.artist}', 'R\$ ${_subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _SummaryRow('Taxa de serviço (5%)', 'R\$ ${_fee.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('R\$ ${_total.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.purple, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('FORMA DE PAGAMENTO', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 12),
            ..._methods.asMap().entries.map((entry) {
              final i = entry.key;
              final m = entry.value;
              final selected = _method == i;
              return GestureDetector(
                onTap: () => setState(() => _method = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.purple.withValues(alpha: 0.08) : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? AppColors.purple : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 26,
                        decoration: BoxDecoration(
                          color: Color(m['color'] as int).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(m['icon'] as String,
                            style: TextStyle(color: Color(m['color'] as int), fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(m['sub'] as String, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        width: 18, height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? AppColors.purple : Colors.transparent,
                          border: Border.all(color: selected ? AppColors.purple : AppColors.border, width: 1.5),
                        ),
                        child: selected ? const Icon(Icons.check, color: Colors.white, size: 10) : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (_loading)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(children: [
                  const CircularProgressIndicator(color: AppColors.purple, strokeWidth: 2),
                  const SizedBox(height: 12),
                  const Text('Processando pagamento...', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ]),
              )
            else
              PrimaryButton(label: 'Confirmar pagamento · R\$ ${_total.toStringAsFixed(0)}', onTap: _pay),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outlined, color: AppColors.textMuted, size: 12),
                SizedBox(width: 4),
                Text('Ambiente 100% seguro · SSL · ShowPass', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis)),
        Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
