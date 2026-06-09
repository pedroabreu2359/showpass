import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../models/ticket_model.dart';

class MyTicketsScreen extends StatelessWidget {
  final bool embedded;
  const MyTicketsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final tickets = AppState().tickets;
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          Container(
            color: AppColors.bgMid,
            padding: EdgeInsets.fromLTRB(20, embedded ? 60 : MediaQuery.of(context).padding.top + 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Meus Ingressos 🎟', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                Text('${tickets.length} ingresso${tickets.length != 1 ? 's' : ''}', style: const TextStyle(color: AppColors.pink, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tickets.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🎟', style: TextStyle(fontSize: 50)),
                    const SizedBox(height: 12),
                    const Text('Nenhum ingresso ainda', style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
                    const SizedBox(height: 6),
                    const Text('Compre seu primeiro ingresso!', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  itemCount: tickets.length,
                  itemBuilder: (_, i) => _TicketPass(ticket: tickets[i]),
                ),
          ),
        ],
      ),
    );
  }
}

class _TicketPass extends StatefulWidget {
  final PurchasedTicket ticket;
  const _TicketPass({required this.ticket});

  @override
  State<_TicketPass> createState() => _TicketPassState();
}

class _TicketPassState extends State<_TicketPass> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tk = widget.ticket;
    final ev = tk.event;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            // Top — event info
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color(int.parse('FF${ev.imageColor}', radix: 16)).withValues(alpha: 0.4),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ev.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text(ev.name, style: const TextStyle(color: AppColors.textMuted, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Text(ev.imageEmoji, style: const TextStyle(fontSize: 32)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: [
                      _Tag('${tk.ticketType.badge} ${tk.ticketType.name}', AppColors.purple),
                      _Tag(ev.date, AppColors.pink),
                      _Tag(ev.time, AppColors.textMuted),
                    ],
                  ),
                ],
              ),
            ),

            // Perforation
            Row(
              children: [
                const _Notch(),
                Expanded(child: LayoutBuilder(
                  builder: (_, c) => Wrap(
                    children: List.generate((c.maxWidth / 8).floor(), (_) => Container(
                      width: 4, height: 1, margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: AppColors.border,
                    )),
                  ),
                )),
                const _Notch(),
              ],
            ),

            // Bottom — details & QR
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // Info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoCol('LOCAL', ev.venue),
                      _InfoCol('HORÁRIO', ev.time),
                      _InfoCol('ASSENTO', tk.seatCode),
                      _InfoCol('QTD', '${tk.quantity}x'),
                    ],
                  ),

                  if (_expanded) ...[
                    const SizedBox(height: 16),
                    // QR Code
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: QrImageView(
                          data: tk.qrCode,
                          version: QrVersions.auto,
                          size: 140,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(tk.qrCode, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 1), textAlign: TextAlign.center),
                  ] else ...[
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.qr_code_2, color: AppColors.purple, size: 14),
                        SizedBox(width: 5),
                        Text('Toque para ver QR Code', style: TextStyle(color: AppColors.purple, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.textMuted, size: 11),
                      const SizedBox(width: 4),
                      Text('Comprado em ${tk.purchaseDate}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoCol extends StatelessWidget {
  final String label, value;
  const _InfoCol(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 8, letterSpacing: 1)),
      const SizedBox(height: 3),
      Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
    ]);
  }
}

class _Notch extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16, height: 16,
      decoration: const BoxDecoration(color: AppColors.bgDeep, shape: BoxShape.circle),
    );
  }
}
