import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    final user = state.user;
    final tickets = state.tickets;
    final favorites = state.favorites;
    final prefs = state.preferences;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.bgMid,
              padding: EdgeInsets.fromLTRB(20, embedded ? 60 : MediaQuery.of(context).padding.top + 16, 20, 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.purple,
                    child: Text(
                      user?.initials ?? 'U',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? 'Usuário', style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _Badge('🎟 ${tickets.length} shows', AppColors.purple),
                      _Badge('⭐ VIP Member', AppColors.pink),
                    ],
                  ),
                ],
              ),
            ),

            // Stats row
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  _Stat('${tickets.length}', 'Ingressos'),
                  _StatDivider(),
                  _Stat('${favorites.length}', 'Favoritos'),
                  _StatDivider(),
                  _Stat('${prefs.length}', 'Gêneros'),
                ],
              ),
            ),

            // Recent purchases
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Conta'),
                  const SizedBox(height: 10),
                  _MenuCard(items: [
                    _MenuItem(icon: Icons.confirmation_number_outlined, label: 'Histórico de compras', value: '${tickets.length} ingressos', onTap: () {}),
                    _MenuItem(icon: Icons.favorite_border, label: 'Eventos favoritos', value: '${favorites.length} eventos', onTap: () {}),
                    _MenuItem(icon: Icons.notifications_outlined, label: 'Notificações', value: '', onTap: () {}),
                    _MenuItem(icon: Icons.card_giftcard, label: 'Meus vouchers', value: '', onTap: () {}),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Music prefs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionHeader(title: 'Gostos musicais'),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.musicTaste),
                        child: const Text('Editar', style: TextStyle(color: AppColors.pink, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  prefs.isEmpty
                    ? const Text('Nenhum gosto salvo ainda.', style: TextStyle(color: AppColors.textMuted, fontSize: 12))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: prefs.map((p) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.purple.withOpacity(0.4)),
                          ),
                          child: Text(p, style: const TextStyle(color: AppColors.purpleLight, fontSize: 12, fontWeight: FontWeight.w600)),
                        )).toList(),
                      ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Configurações'),
                  const SizedBox(height: 10),
                  _MenuCard(items: [
                    _MenuItem(icon: Icons.person_outline, label: 'Editar perfil', value: '', onTap: () {}),
                    _MenuItem(icon: Icons.lock_outlined, label: 'Privacidade', value: '', onTap: () {}),
                    _MenuItem(icon: Icons.help_outline, label: 'Ajuda e suporte', value: '', onTap: () {}),
                    _MenuItem(icon: Icons.info_outline, label: 'Sobre o ShowPass', value: 'v1.0.0', onTap: () {}),
                  ]),
                  const SizedBox(height: 12),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.logout,
                      label: 'Sair da conta',
                      value: '',
                      labelColor: AppColors.pinkLight,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: AppColors.bgCard,
                            title: const Text('Sair da conta', style: TextStyle(color: AppColors.textPrimary)),
                            content: const Text('Tem certeza que deseja sair?', style: TextStyle(color: AppColors.textSecondary)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
                                },
                                child: const Text('Sair', style: TextStyle(color: AppColors.pink)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
    ]));
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.border);
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final last = e.key == items.length - 1;
          return Column(children: [
            item,
            if (!last) const Divider(height: 1, color: AppColors.bgDeep),
          ]);
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color? labelColor;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.value, required this.onTap, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: labelColor ?? AppColors.textSecondary, size: 16),
      ),
      title: Text(label, style: TextStyle(color: labelColor ?? AppColors.textPrimary, fontSize: 13)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty) Text(value, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
        ],
      ),
    );
  }
}
