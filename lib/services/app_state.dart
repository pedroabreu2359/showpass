import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart';
import '../data/mock_events.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

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

  void login(String name, String email) {
    _user = UserModel(
      id: 'user_001',
      name: name,
      email: email,
      musicPreferences: _preferences,
    );
    // Pre-populate with a sample ticket for demo
    if (_tickets.isEmpty) {
      _addDemoTicket();
    }
    notifyListeners();
  }

  void _addDemoTicket() {
    final event = _events.first;
    _tickets.insert(0, PurchasedTicket(
      id: 'tkt_demo_001',
      event: event,
      ticketType: event.ticketTypes[1],
      quantity: 2,
      totalPrice: event.ticketTypes[1].price * 2,
      purchaseDate: '01 Jun 2025',
      seatCode: 'VIP A-14',
      qrCode: 'SP-CLD-20250722-VIP-A14#4F2BX9',
    ));
  }

  void savePreferences(List<String> prefs) {
    _preferences = prefs;
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        musicPreferences: prefs,
      );
    }
    notifyListeners();
  }

  void toggleFavorite(String eventId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      _events[idx].isFavorite = !_events[idx].isFavorite;
      notifyListeners();
    }
  }

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
      qrCode: '${event.city.substring(0,2).toUpperCase()}-${event.id.toUpperCase()}-${ticketType.id.toUpperCase()}#${_randomCode()}',
    );
    _tickets.insert(0, ticket);
    notifyListeners();
    return ticket;
  }

  List<EventModel> getRecommended() {
    if (_preferences.isEmpty) return featuredEvents;
    final result = _events.where((e) => _preferences.contains(e.category)).toList();
    if (result.isEmpty) return featuredEvents;
    return result;
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2,'0')} ${_months[d.month-1]} ${d.year}';
  String _generateSeat(String type) {
    final zones = {'VIP': 'VIP', 'Pista': 'PST', 'Camarote': 'CAM', 'Meia Entrada': 'PST'};
    final zone = zones[type] ?? 'GRL';
    return '$zone ${String.fromCharCode(65 + DateTime.now().second % 8)}-${(DateTime.now().millisecond % 50) + 1}';
  }
  String _randomCode() => DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase().substring(0,6);

  static const _months = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
}
