import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart';
import '../data/mock_events.dart';
import 'database_helper.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final _db = DatabaseHelper();

  // User
  UserModel? _user;
  UserModel? get user => _user;

  // Events
  final List<EventModel> _events = MockEvents.all;
  List<EventModel> get events => _events;
  List<EventModel> get featuredEvents => MockEvents.featured;

  // Purchased tickets
  final List<PurchasedTicket> _tickets = [];
  List<PurchasedTicket> get tickets => _tickets;

  // Music preferences
  List<String> _preferences = [];
  List<String> get preferences => _preferences;

  // Favorites
  List<EventModel> get favorites => _events.where((e) => e.isFavorite).toList();

  // ── INICIALIZAÇÃO ─────────────────────────────────
  // Chamar no splash screen antes de navegar
  Future<void> loadFromDatabase() async {
    _user = await _db.loadUser();
    if (_user != null) {
      _preferences = _user!.musicPreferences;
      // só carrega tickets e favoritos se tiver usuário salvo
      final favIds = await _db.loadFavoriteIds();
      for (final e in _events) {
        e.isFavorite = favIds.contains(e.id);
      }
      _tickets
        ..clear()
        ..addAll(await _db.loadTickets());
    }
    notifyListeners();
  }

  // ── LOGIN / LOGOUT ────────────────────────────────
  void login(String name, String email) {
    // se o email for diferente do salvo, limpa tudo antes
    if (_user != null && _user!.email != email) {
      logout(); // limpa banco e estado
    }

    _user = UserModel(
      id: 'user_${email.hashCode.abs()}', // ID único por email
      name: name,
      email: email,
      musicPreferences: _preferences,
    );
    _db.saveUser(_user!);
    if (_tickets.isEmpty) _addDemoTicket();
    notifyListeners();
  }

  void logout() {
    _user = null;
    _preferences = [];
    _tickets.clear();
    for (final e in _events) {
      e.isFavorite = false;
    }
    _db.deleteUser();
    notifyListeners();
  }

  void _addDemoTicket() {
    final event = _events.first;
    final ticket = PurchasedTicket(
      id: 'tkt_demo_001',
      event: event,
      ticketType: event.ticketTypes[1],
      quantity: 2,
      totalPrice: event.ticketTypes[1].price * 2,
      purchaseDate: '01 Jun 2025',
      seatCode: 'VIP A-14',
      qrCode: 'SP-CLD-20250722-VIP-A14#4F2BX9',
    );
    _tickets.insert(0, ticket);
    _db.saveTicket(ticket);
  }

  // ── PREFERÊNCIAS ──────────────────────────────────
  void savePreferences(List<String> prefs) {
    _preferences = prefs;
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        musicPreferences: prefs,
      );
      _db.saveUser(_user!);
    }
    notifyListeners();
  }

  // ── FAVORITOS ─────────────────────────────────────
  void toggleFavorite(String eventId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _events[idx].isFavorite = !_events[idx].isFavorite;
      if (_events[idx].isFavorite) {
        _db.saveFavorite(eventId);
      } else {
        _db.deleteFavorite(eventId);
      }
      notifyListeners();
    }
  }

  // ── COMPRA DE TICKET ──────────────────────────────
  PurchasedTicket purchaseTicket({
    required EventModel event,
    required TicketType ticketType,
    required int quantity,
  }) {
    final ticket = PurchasedTicket(
      id: 'tkt_${DateTime.now().millisecondsSinceEpoch}',
      event: event,
      ticketType: ticketType,
      quantity: quantity,
      totalPrice: ticketType.price * quantity,
      purchaseDate: _formatDate(DateTime.now()),
      seatCode: _generateSeat(ticketType.name),
      qrCode:
      '${event.city.substring(0, 2).toUpperCase()}-${event.id.toUpperCase()}-${ticketType.id.toUpperCase()}#${_randomCode()}',
    );
    _tickets.insert(0, ticket);
    _db.saveTicket(ticket);
    notifyListeners();
    return ticket;
  }

  // ── RECOMENDAÇÕES ─────────────────────────────────
  List<EventModel> getRecommended() {
    if (_preferences.isEmpty) return featuredEvents;
    final result =
    _events.where((e) => _preferences.contains(e.category)).toList();
    if (result.isEmpty) return featuredEvents;
    return result;
  }

  // ── HELPERS PRIVADOS ──────────────────────────────
  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  String _generateSeat(String type) {
    final zones = {
      'VIP': 'VIP',
      'Pista': 'PST',
      'Camarote': 'CAM',
      'Meia Entrada': 'PST'
    };
    final zone = zones[type] ?? 'GRL';
    return '$zone ${String.fromCharCode(65 + DateTime.now().second % 8)}-${(DateTime.now().millisecond % 50) + 1}';
  }

  String _randomCode() => DateTime.now()
      .millisecondsSinceEpoch
      .toRadixString(36)
      .toUpperCase()
      .substring(0, 6);

  static const _months = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
  ];
}