import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../services/app_state.dart';
import '../widgets/shared_widgets.dart';
import '../models/event_model.dart';
import 'search_screen.dart';
import 'my_tickets_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  String _selectedCat = 'Pop';

  static const _categories = [
    {'label': 'Pop',       'emoji': '🎤'},
    {'label': 'Rock',      'emoji': '🎸'},
    {'label': 'Eletrônica','emoji': '🎧'},
    {'label': 'Festivais', 'emoji': '🎪'},
    {'label': 'Sertanejo', 'emoji': '🤠'},
    {'label': 'Pagode',    'emoji': '🥁'},
    {'label': 'Funk',      'emoji': '🔊'},
    {'label': 'Trap',      'emoji': '🎤'},
    {'label': 'Teatro',    'emoji': '🎭'},
    {'label': 'Esportes',  'emoji': '⚽'},
  ];

  void _goToDetail(EventModel event) =>
      Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: event);

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'manhã';
    if (h < 18) return 'tarde';
    return 'noite';
  }

  Widget _buildHome() {
    final state = AppState();
    final featured = state.featuredEvents;
    final recommended = state.getRecommended();
    final byCategory = state.events.where((e) => e.category == _selectedCat).toList();
    final catEmoji = _categories.firstWhere((c) => c['label'] == _selectedCat)['emoji']!;

    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      color: AppColors.purple,
      child: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.bgMid,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
              child: Row(children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Boa ${_greeting()},', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Text('${state.user?.name.split(' ').first ?? 'Visitante'} 👋',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                  ],
                )),
                IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.pink), onPressed: () {}),
                GestureDetector(
                  onTap: () => setState(() => _navIndex = 3),
                  child: CircleAvatar(radius: 18, backgroundColor: AppColors.purple,
                    child: Text(state.user?.initials ?? 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                ),
              ]),
            ),
          ),

          // ── Banner destaque ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: featured.isEmpty ? const SizedBox() :
                GradientEventBanner(event: featured[0], onTap: () => _goToDetail(featured[0])),
            ),
          ),

          // ── Dots paginação ────────────────────────
          SliverToBoxAdapter(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(featured.take(4).length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: i == 0 ? 16 : 6, height: 6,
                decoration: BoxDecoration(
                  color: i == 0 ? AppColors.purple : AppColors.border,
                  borderRadius: BorderRadius.circular(3)),
              ))),
          ),

          // ── Categorias ────────────────────────────
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(title: 'Categorias')),
              const SizedBox(height: 10),
              SizedBox(height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    final isSelected = _selectedCat == cat['label'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryChip(
                        label: cat['label']!,
                        emoji: cat['emoji']!,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedCat = cat['label']!),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),

          // ── Eventos da categoria selecionada ──────
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: '$catEmoji $_selectedCat em alta',
                  actionLabel: 'Ver todos (${byCategory.length})',
                  onAction: () {},
                )),
              const SizedBox(height: 12),
              if (byCategory.isEmpty)
                const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Nenhum evento nesta categoria.', style: TextStyle(color: AppColors.textMuted)))
              else
                SizedBox(height: 196,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: byCategory.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: EventCard(event: byCategory[i], onTap: () => _goToDetail(byCategory[i])),
                    ),
                  ),
                ),
            ]),
          ),

          // ── Recomendados para você ────────────────
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Recomendados para você',
                  actionLabel: 'Ver todos',
                  onAction: () => setState(() => _navIndex = 1),
                )),
              const SizedBox(height: 12),
              SizedBox(height: 196,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recommended.take(8).length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: EventCard(event: recommended[i], onTap: () => _goToDetail(recommended[i])),
                  ),
                ),
              ),
            ]),
          ),

          // ── Destaques da semana ───────────────────
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Destaques da semana',
                  actionLabel: 'Ver todos',
                  onAction: () => setState(() => _navIndex = 1),
                )),
              const SizedBox(height: 12),
              SizedBox(height: 196,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: featured.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: EventCard(event: featured[i], onTap: () => _goToDetail(featured[i]), width: 170),
                  ),
                ),
              ),
            ]),
          ),

          // ── Lista completa da categoria ───────────
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(title: 'Todos os eventos de $_selectedCat')),
              const SizedBox(height: 12),
              ...byCategory.map((ev) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: EventListTile(event: ev, onTap: () => _goToDetail(ev)),
              )),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const SearchScreen(embedded: true),
      const MyTicketsScreen(embedded: true),
      const ProfileScreen(embedded: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: pages[_navIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgMid,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.purpleLight,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), activeIcon: Icon(Icons.confirmation_number), label: 'Ingressos'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
