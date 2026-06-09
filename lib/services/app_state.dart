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

  Future<void> loadFromDatabase() async {
    _user = await _db.loadUser();
    if (_user != null) {
      _preferences = _user!.musicPreferences;
      final favIds = await _db.loadFavoriteIds(_user!.id);
      for (final e in _events) {
        e.isFavorite = favIds.contains(e.id);
      }
      _tickets
        ..clear()
        ..addAll(await _db.loadTickets(_user!.id));
    }
    notifyListeners();
  }

  // ── LOGIN ─────────────────────────────────────────

  // Tenta logar com email + senha.
  // Retorna null em caso de sucesso; mensagem de erro caso contrário.
  Future<String?> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Preencha e-mail e senha.';
    }

    final found = await _db.findUserByEmailAndPassword(
        email.trim().toLowerCase(), password);

    if (found == null) {
      final emailRegistered = await _db.emailExists(email.trim().toLowerCase());
      if (!emailRegistered) return 'E-mail não cadastrado.';
      return 'Senha incorreta.';
    }

    _user = found;
    _preferences = found.musicPreferences;
    await _db.setLoggedIn(found.id, true);

    final favIds = await _db.loadFavoriteIds(found.id);
    for (final e in _events) {
      e.isFavorite = favIds.contains(e.id);
    }
    _tickets
      ..clear()
      ..addAll(await _db.loadTickets(found.id));

    notifyListeners();
    return null;
  }

  // Login via provedor social (Google / Apple).
  // Cria conta se não existir, loga diretamente se já existir.
  Future<void> loginWithProvider(String providerName, String displayName) async {
    final email =
        '${displayName.toLowerCase().replaceAll(' ', '.')}.${providerName.toLowerCase()}@socialauth.showpass';
    final socialPassword = 'social_${providerName.toLowerCase()}_auth';

    final existing = await _db.findUserByEmailAndPassword(email, socialPassword);
    if (existing != null) {
      await _db.setLoggedIn(existing.id, true);
      _user = existing;
      _preferences = existing.musicPreferences;
      final favIds = await _db.loadFavoriteIds(existing.id);
      for (final e in _events) {
        e.isFavorite = favIds.contains(e.id);
      }
      _tickets
        ..clear()
        ..addAll(await _db.loadTickets(existing.id));
    } else {
      final newUser = UserModel(
        id: 'user_${email.hashCode.abs()}',
        name: displayName,
        email: email,
        password: socialPassword,
        musicPreferences: [],
      );
      await _db.saveUser(newUser);
      await _db.setLoggedIn(newUser.id, true);
      _user = newUser;
      _preferences = [];
    }
    notifyListeners();
  }

  void updateName(String newName) {
    if (_user == null) return;
    _user = UserModel(
      id: _user!.id,
      name: newName,
      email: _user!.email,
      password: _user!.password,
      musicPreferences: _user!.musicPreferences,
    );
    _db.saveUser(_user!);
    notifyListeners();
  }

  void logout() async {
    if (_user != null) {
      await _db.setLoggedIn(_user!.id, false);
    }
    _user = null;
    _preferences = [];
    _tickets.clear();
    for (final e in _events) {
      e.isFavorite = false;
    }
    notifyListeners();
  }

  // ── SIGNUP ────────────────────────────────────────

  // Cria nova conta.
  // Retorna null em caso de sucesso; mensagem de erro caso contrário.
  Future<String?> signup(String name, String email, String password) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return 'Preencha todos os campos.';
    }

    final alreadyExists = await _db.emailExists(email.trim().toLowerCase());
    if (alreadyExists) return 'E-mail já cadastrado.';

    final newUser = UserModel(
      id: 'user_${email.trim().hashCode.abs()}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      musicPreferences: [],
    );
    await _db.saveUser(newUser);
    await _db.setLoggedIn(newUser.id, true);
    _user = newUser;
    _preferences = [];
    notifyListeners();
    return null;
  }

  // ── PREFERÊNCIAS ──────────────────────────────────

  void savePreferences(List<String> prefs) {
    _preferences = prefs;
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        password: _user!.password,
        musicPreferences: prefs,
      );
      _db.saveUser(_user!);
    }
    notifyListeners();
  }

  // ── FAVORITOS ─────────────────────────────────────

  void toggleFavorite(String eventId) {
    if (_user == null) return;

    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _events[idx].isFavorite = !_events[idx].isFavorite;
      if (_events[idx].isFavorite) {
        _db.saveFavorite(eventId, _user!.id);
      } else {
        _db.deleteFavorite(eventId, _user!.id);
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
    _db.saveTicket(ticket, _user!.id);
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