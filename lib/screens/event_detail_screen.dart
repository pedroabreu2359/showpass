import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool get _isFav => widget.event.isFavorite;

  void _toggleFav() {
    AppState().toggleFavorite(widget.event.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ev = widget.event;
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.bgMid,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.bgDeep.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.bgDeep.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                  child: Icon(_isFav ? Icons.favorite : Icons.favorite_border, color: AppColors.pink, size: 20),
                ),
                onPressed: _toggleFav,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color(int.parse('FF${ev.imageColor}', radix: 16)),
                child: Center(child: Text(ev.imageEmoji, style: const TextStyle(fontSize: 80))),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  AppBadge(label: ev.category, bgColor: AppColors.purple.withOpacity(0.3), textColor: AppColors.purpleLight),
                  const SizedBox(height: 10),

                  // Title
                  Text(ev.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(ev.name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),

                  // Info row
                  _InfoRow(icon: Icons.calendar_today, text: '${ev.date} · ${ev.time}'),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.location_on, text: '${ev.venue}, ${ev.city}'),
                  const SizedBox(height: 16),

                  // Lote alert
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: const [
                        Text('⚠️', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Virada de lote em 2 horas! Garanta o seu preço atual.',
                          style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Sobre o evento', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(ev.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
                  const SizedBox(height: 20),

                  // Mini map
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.bgMid,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
                          ),
                          child: const Center(child: Text('🗺', style: TextStyle(fontSize: 30))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ev.venue, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(ev.city, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              const SizedBox(height: 3),
                              const Text('Ver no mapa →', style: TextStyle(color: AppColors.purple, fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Playlist
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
                          child: const Center(child: Text('S', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Playlist ${ev.artist} · Essentials', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                              const Text('32 músicas · Spotify', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            ],
                          ),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
                          child: const Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 18)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price preview
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('A partir de', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          Text('R\$ ${ev.basePrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Comprar Ingresso',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.ticketSelect, arguments: ev),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 15),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
      ],
    );
  }
}
