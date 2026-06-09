import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import '../models/event_model.dart';

class SearchScreen extends StatefulWidget {
  final bool embedded;
  const SearchScreen({super.key, this.embedded = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  String _catFilter = 'Todos';
  String _priceFilter = 'Todos';

  static const _cats = ['Todos', 'Pop', 'Rock', 'Eletrônica', 'Sertanejo', 'Funk', 'Festivais', 'Teatro', 'Esportes', 'Trap', 'Pagode'];
  static const _prices = ['Todos', 'Até R\$100', 'R\$100–300', 'R\$300–600', 'Acima de R\$600'];

  List<EventModel> get _results {
    var list = _query.isEmpty ? AppState().events : AppState().events.where((e) {
      final q = _query.toLowerCase();
      return e.name.toLowerCase().contains(q) || e.artist.toLowerCase().contains(q) ||
        e.category.toLowerCase().contains(q) || e.city.toLowerCase().contains(q);
    }).toList();
    if (_catFilter != 'Todos') list = list.where((e) => e.category == _catFilter).toList();
    if (_priceFilter != 'Todos') {
      list = list.where((e) {
        switch (_priceFilter) {
          case 'Até R\$100': return e.basePrice <= 100;
          case 'R\$100–300': return e.basePrice > 100 && e.basePrice <= 300;
          case 'R\$300–600': return e.basePrice > 300 && e.basePrice <= 600;
          case 'Acima de R\$600': return e.basePrice > 600;
          default: return true;
        }
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          Container(
            color: AppColors.bgMid,
            padding: EdgeInsets.fromLTRB(20, widget.embedded ? 60 : MediaQuery.of(context).padding.top + 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Buscar Eventos', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Shows, artistas, festivais...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    suffixIcon: _query.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18), onPressed: () { _ctrl.clear(); setState(() => _query = ''); })
                      : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: _cats.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _catFilter = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: _catFilter == c ? AppColors.purple : AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _catFilter == c ? AppColors.purple : AppColors.border),
                    ),
                    child: Text(c, style: TextStyle(
                      color: _catFilter == c ? Colors.white : AppColors.textSecondary,
                      fontSize: 11, fontWeight: FontWeight.w600,
                    )),
                  ),
                ),
              )).toList(),
            ),
          ),
          // Price filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: _prices.map((p) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _priceFilter = p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: _priceFilter == p ? AppColors.pink.withValues(alpha: 0.2) : AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _priceFilter == p ? AppColors.pink : AppColors.border),
                    ),
                    child: Text(p, style: TextStyle(
                      color: _priceFilter == p ? AppColors.pinkLight : AppColors.textSecondary,
                      fontSize: 11, fontWeight: FontWeight.w600,
                    )),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${results.length} evento${results.length != 1 ? 's' : ''} encontrado${results.length != 1 ? 's' : ''}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🔍', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(_query.isEmpty ? 'Busque por um evento' : 'Nenhum evento encontrado',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: results.length,
                  itemBuilder: (_, i) => EventListTile(
                    event: results[i],
                    onTap: () => Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: results[i]),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
