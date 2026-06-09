import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/event_model.dart';

// ─── EVENT CARD ───────────────────────────────────────────────

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final double width;

  const EventCard({super.key, required this.event, required this.onTap, this.width = 160});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: Color(int.parse('FF${event.imageColor}', radix: 16)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(
                child: Text(event.imageEmoji, style: const TextStyle(fontSize: 36)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(event.name, style: const TextStyle(color: AppColors.textMuted, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 9, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Expanded(child: Text(event.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 8), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('A partir de R\$ ${event.basePrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.pink, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── EVENT LIST TILE ───────────────────────────────────────────

class EventListTile extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventListTile({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: Color(int.parse('FF${event.imageColor}', radix: 16)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(event.imageEmoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(event.name, style: const TextStyle(color: AppColors.textMuted, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.calendar_today, size: 9, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text('${event.date} · ${event.time}', style: const TextStyle(color: AppColors.textMuted, fontSize: 8)),
                  ]),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on, size: 9, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Expanded(child: Text('${event.venue}, ${event.city}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 8), overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 4),
                  Text('A partir de R\$ ${event.basePrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.pink, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── CATEGORY CHIP ───────────────────────────────────────────

class CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label, required this.emoji, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withValues(alpha: 0.2) : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.purple : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(
              color: isSelected ? AppColors.purpleLight : AppColors.textSecondary,
              fontSize: 11, fontWeight: FontWeight.w600,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(color: AppColors.pink, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ─── PRIMARY BUTTON ──────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;

  const PrimaryButton({super.key, required this.label, required this.onTap, this.isLoading = false, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.purple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}

// ─── BADGE ───────────────────────────────────────────────────

class AppBadge extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color? textColor;

  const AppBadge({super.key, required this.label, this.bgColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.pink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

// ─── GRADIENT CARD ───────────────────────────────────────────

class GradientEventBanner extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const GradientEventBanner({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Color(int.parse('FF${event.imageColor}', radix: 16)),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Stack(
          children: [
            Positioned(right: 16, top: 0, bottom: 0,
              child: Center(child: Text(event.imageEmoji, style: const TextStyle(fontSize: 70), textAlign: TextAlign.center)),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.transparent, AppColors.bgMid.withValues(alpha: 0.95)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBadge(label: '🔥 DESTAQUE', bgColor: AppColors.pink),
                  const SizedBox(height: 8),
                  Text(event.artist, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(event.name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('📅 ${event.date} · ${event.venue}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Ver ingressos', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
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
