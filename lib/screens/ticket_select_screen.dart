import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/shared_widgets.dart';
import '../models/event_model.dart';

class TicketSelectScreen extends StatefulWidget {
  final EventModel event;
  const TicketSelectScreen({super.key, required this.event});

  @override
  State<TicketSelectScreen> createState() => _TicketSelectScreenState();
}

class _TicketSelectScreenState extends State<TicketSelectScreen> {
  int _selectedIdx = 0;
  int _qty = 1;

  TicketType get _selected => widget.event.ticketTypes[_selectedIdx];
  double get _total => _selected.price * _qty;

  static const _typeColors = [
    AppColors.textSecondary,
    AppColors.pink,
    AppColors.violet,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    final ev = widget.event;
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgMid,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Escolha seu ingresso', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            color: AppColors.bgMid,
            child: Row(children: [
              Text('${ev.artist} · ', style: const TextStyle(color: AppColors.purple, fontSize: 11, fontWeight: FontWeight.w600)),
              Expanded(child: Text('${ev.date} · ${ev.venue}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11), overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: List.generate(ev.ticketTypes.length, (i) {
                  final tk = ev.ticketTypes[i];
                  final selected = _selectedIdx == i;
                  final color = _typeColors[i % _typeColors.length];
                  return GestureDetector(
                    onTap: () => setState(() { _selectedIdx = i; _qty = 1; }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.purple.withOpacity(0.12) : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selected ? AppColors.purple : AppColors.border, width: selected ? 1.5 : 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('${tk.badge} ', style: const TextStyle(fontSize: 16)),
                              Text(tk.name, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                              const Spacer(),
                              Text('R\$ ${tk.price.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...tk.benefits.map((b) => Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: AppColors.purple, size: 14),
                                const SizedBox(width: 8),
                                Text(b, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ),
                          )),
                          if (selected) ...[
                            const SizedBox(height: 14),
                            const Divider(color: AppColors.border),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Quantidade', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                Row(
                                  children: [
                                    _QtyBtn(icon: Icons.remove, onTap: () { if (_qty > 1) setState(() => _qty--); }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      child: Text('$_qty', style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                                    ),
                                    _QtyBtn(icon: Icons.add, onTap: () { if (_qty < 10) setState(() => _qty++); }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
            decoration: const BoxDecoration(
              color: AppColors.bgMid,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total (${_qty}x ${_selected.name})', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('R\$ ${_total.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Pagar agora',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.payment, arguments: {
                    'event': widget.event,
                    'ticketType': _selected,
                    'quantity': _qty,
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
        child: Icon(icon, color: AppColors.textPrimary, size: 16),
      ),
    );
  }
}
