import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/ticket_model.dart';
import '../models/event_model.dart';
import '../data/mock_events.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'showpass.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        music_preferences TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        event_id TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE tickets (
        id TEXT PRIMARY KEY,
        event_id TEXT NOT NULL,
        ticket_type_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        total_price REAL NOT NULL,
        purchase_date TEXT NOT NULL,
        seat_code TEXT NOT NULL,
        qr_code TEXT NOT NULL
      )
    ''');
  }

  // ── USER ──────────────────────────────────────────

  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'user',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'music_preferences': user.musicPreferences.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> loadUser() async {
    final db = await database;
    final rows = await db.query('user', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return UserModel(
      id: row['id'] as String,
      name: row['name'] as String,
      email: row['email'] as String,
      musicPreferences: (row['music_preferences'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
    );
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }

  // ── FAVORITES ─────────────────────────────────────

  Future<void> saveFavorite(String eventId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'event_id': eventId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFavorite(String eventId) async {
    final db = await database;
    await db.delete('favorites', where: 'event_id = ?', whereArgs: [eventId]);
  }

  Future<Set<String>> loadFavoriteIds() async {
    final db = await database;
    final rows = await db.query('favorites');
    return rows.map((r) => r['event_id'] as String).toSet();
  }

  // ── TICKETS ───────────────────────────────────────

  Future<void> saveTicket(PurchasedTicket ticket) async {
    final db = await database;
    await db.insert(
      'tickets',
      {
        'id': ticket.id,
        'event_id': ticket.event.id,
        'ticket_type_id': ticket.ticketType.id,
        'quantity': ticket.quantity,
        'total_price': ticket.totalPrice,
        'purchase_date': ticket.purchaseDate,
        'seat_code': ticket.seatCode,
        'qr_code': ticket.qrCode,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PurchasedTicket>> loadTickets() async {
    final db = await database;
    final rows = await db.query('tickets', orderBy: 'rowid DESC');

    // Mapa de eventos para lookup rápido
    final eventMap = {for (final e in MockEvents.all) e.id: e};

    final List<PurchasedTicket> result = [];
    for (final row in rows) {
      final event = eventMap[row['event_id'] as String];
      if (event == null) continue; // evento removido dos mocks — pular

      final ticketType = event.ticketTypes
          .where((t) => t.id == row['ticket_type_id'] as String)
          .firstOrNull;
      if (ticketType == null) continue;

      result.add(PurchasedTicket(
        id: row['id'] as String,
        event: event,
        ticketType: ticketType,
        quantity: row['quantity'] as int,
        totalPrice: row['total_price'] as double,
        purchaseDate: row['purchase_date'] as String,
        seatCode: row['seat_code'] as String,
        qrCode: row['qr_code'] as String,
      ));
    }
    return result;
  }
}