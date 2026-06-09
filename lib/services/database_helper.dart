import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/ticket_model.dart';
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
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        is_logged_in INTEGER NOT NULL DEFAULT 0,
        music_preferences TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        user_id TEXT NOT NULL,
        event_id TEXT NOT NULL,
        PRIMARY KEY (user_id, event_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tickets (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE user ADD COLUMN password TEXT NOT NULL DEFAULT ''");
    }
    if (oldVersion < 3) {
      await db.execute(
          "ALTER TABLE user ADD COLUMN is_logged_in INTEGER NOT NULL DEFAULT 0");
    }
    if (oldVersion < 5) {
      await db.execute(
          "ALTER TABLE tickets ADD COLUMN user_id TEXT NOT NULL DEFAULT ''");
    }
    if (oldVersion < 6) {
      await db.execute("DROP TABLE IF EXISTS favorites");
      await db.execute('''
        CREATE TABLE favorites (
          user_id TEXT NOT NULL,
          event_id TEXT NOT NULL,
          PRIMARY KEY (user_id, event_id)
        )
      ''');
    }
  }

  // ── USER ──────────────────────────────────────────

  Future<void> saveUser(UserModel user) async {
    final db = await database;
    final exists = await emailExists(user.email);
    if (exists) {
      await db.update(
        'user',
        {
          'name': user.name,
          'password': user.password,
          'music_preferences': user.musicPreferences.join(','),
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } else {
      await db.insert('user', {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'is_logged_in': 0,
        'music_preferences': user.musicPreferences.join(','),
      });
    }
  }

  /// Retorna o usuário logado (sessão atual — apenas 1 registro na tabela).
  Future<UserModel?> loadUser() async {
    final db = await database;
    final rows = await db.query('user',
        where: 'is_logged_in = ?', whereArgs: [1], limit: 1);
    if (rows.isEmpty) return null;
    return _rowToUser(rows.first);
  }

  Future<void> setLoggedIn(String userId, bool loggedIn) async {
    final db = await database;
    await db.update(
      'user',
      {'is_logged_in': loggedIn ? 1 : 0},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Verifica credenciais e retorna o usuário se corretas; null caso contrário.
  Future<UserModel?> findUserByEmailAndPassword(
      String email, String password) async {
    final db = await database;
    final rows = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
    );
    if (rows.isEmpty) return null;
    return _rowToUser(rows.first);
  }

  /// Verifica se um e-mail já está cadastrado.
  Future<bool> emailExists(String email) async {
    final db = await database;
    final rows = await db.query(
      'user',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    return rows.isNotEmpty;
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }

  UserModel _rowToUser(Map<String, dynamic> row) {
    return UserModel(
      id: row['id'] as String,
      name: row['name'] as String,
      email: row['email'] as String,
      password: row['password'] as String,
      musicPreferences: (row['music_preferences'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
    );
  }

  // ── FAVORITES ─────────────────────────────────────

  Future<void> saveFavorite(String eventId, String userId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'event_id': eventId,
        'user_id': userId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFavorite(String eventId, String userId) async {
    final db = await database;
    await db.delete(
        'favorites',
        where: 'event_id = ? AND user_id = ?',
        whereArgs: [eventId, userId]
    );
  }

  Future<Set<String>> loadFavoriteIds(String userId) async {
    final db = await database;
    final rows = await db.query(
        'favorites',
        where: 'user_id = ?',
        whereArgs: [userId] // Busca apenas os favoritos deste usuário!
    );
    return rows.map((r) => r['event_id'] as String).toSet();
  }

  // ── TICKETS ───────────────────────────────────────

  Future<void> saveTicket(PurchasedTicket ticket, String userId) async {
    final db = await database;
    await db.insert(
      'tickets',
      {
        'id': ticket.id,
        'user_id': userId,
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

  Future<List<PurchasedTicket>> loadTickets(String userId) async {
    final db = await database;
    final rows = await db.query('tickets',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'rowid DESC');

    final eventMap = {for (final e in MockEvents.all) e.id: e};
    final List<PurchasedTicket> result = [];

    for (final row in rows) {
      final event = eventMap[row['event_id'] as String];
      if (event == null) continue;
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