import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';

class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  final Set<String> _selected = {};

  static const _categories = [
    {'label': 'Pop', 'emoji': '🎤', 'desc': 'Taylor Swift, Dua Lipa'},
    {'label': 'Rock', 'emoji': '🎸', 'desc': 'Coldplay, Imagine Dragons'},
    {'label': 'Pagode', 'emoji': '🥁', 'desc': 'Ivete Sangalo, Péricles'},
    {'label': 'Funk', 'emoji': '🔊', 'desc': 'Anitta, MC Kevinho'},
    {'label': 'Sertanejo', 'emoji': '🤠', 'desc': 'Ana Castela, Gusttavo Lima'},
    {'label': 'Eletrônica', 'emoji': '🎧', 'desc': 'Alok, Tomorrowland'},
    {'label': 'Trap', 'emoji': '🎤', 'desc': 'Matuê, Don L'},
    {'label': 'Festivais', 'emoji': '🎪', 'desc': 'Lollapalooza, Rock in Rio'},
    {'label': 'Teatro', 'emoji': '🎭', 'desc': 'Musicais, Stand-up'},
    {'label': 'Esportes', 'emoji': '⚽', 'desc': 'Futebol, MMA, Basquete'},
  ];

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) _selected.remove(label);
      else _selected.add(label);
    });
  }

  void _continue() {
    if (_selected.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos 3 categorias'), backgroundColor: AppColors.purple),
      );
      return;
    }
    AppState().savePreferences(_selected.toList());
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.bgMid,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Seus gostos musicais 🎵', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('Escolha estilos para receber recomendações personalizadas', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 14),
                // Progress bar
                Row(children: [
                  Expanded(child: Container(height: 3, decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 3, decoration: BoxDecoration(color: AppColors.pink.withOpacity(0.5), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 3, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
                ]),
                const SizedBox(height: 10),
                Text(
                  _selected.length < 3 ? 'Selecione ao menos 3 categorias' : '${_selected.length} selecionadas ✓',
                  style: TextStyle(color: _selected.length >= 3 ? AppColors.success : AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          // Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final label = cat['label']!;
                  final selected = _selected.contains(label);
                  return GestureDetector(
                    onTap: () => _toggle(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.purple.withOpacity(0.2) : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? AppColors.purple : AppColors.border,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cat['emoji']!, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label, style: TextStyle(
                                color: selected ? AppColors.purpleLight : AppColors.textPrimary,
                                fontSize: 13, fontWeight: FontWeight.w700,
                              )),
                              Text(cat['desc']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            ],
                          ),
                          if (selected) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle, color: AppColors.purple, size: 16),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Bottom button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
            child: PrimaryButton(
              label: _selected.length >= 3 ? 'Continuar → (${_selected.length} selecionadas)' : 'Selecione ao menos 3',
              onTap: _continue,
              color: _selected.length >= 3 ? AppColors.purple : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
