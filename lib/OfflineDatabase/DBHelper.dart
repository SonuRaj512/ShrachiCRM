import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../api/checkin_controller.dart';
import '../utils/internet_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shrachi_offline.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. Table to store API data for offline viewing (Cache)
    await db.execute('''
      CREATE TABLE tour_plans (
        id INTEGER PRIMARY KEY,
        data TEXT NOT NULL
      )
    ''');

    // 2. Table to store actions (Insert/Update/Delete) to be synced later
    await db.execute('''
      CREATE TABLE pending_sync (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_type TEXT, -- 'INSERT', 'UPDATE', 'DELETE'
        tour_id INTEGER,
        payload TEXT -- JSON string of the object
      )
    ''');
    /// 3. Table to store OFFLINE CHECK-IN DATA
    await db.execute('''
      CREATE TABLE offline_checkin (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lat REAL, lng REAL, tourPlanId INTEGER, visitId INTEGER,
        convinceType TEXT, convinceText TEXT, checkIn_distance REAL,
        createdAt TEXT,
        retry_count INTEGER DEFAULT 0,
        last_retry_at TEXT
      )
    ''');
    print('offline_checkin');
    await db.execute('''
      CREATE TABLE offline_checkout (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lat REAL, lng REAL, tourPlanId INTEGER, visitId INTEGER,
        images TEXT, additionalInfo TEXT, startDate TEXT,
        createdAt TEXT,
        retry_count INTEGER DEFAULT 0,
        last_retry_at TEXT
      )
    ''');
  }
  // 🔥 DEBUG METHOD: Console mein sabhi tables ka data dekhne ke liye
  Future<void> debugAllTablesData() async {
    try {
      final db = await database;
      print("\n**************************************************");
      print("🚀 [SQLITE DEBUG] DATABASE INSPECTION STARTED");
      print("**************************************************");

      // Sabhi tables ke naam nikalna (system tables ko chhod kar)
      var tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_metadata'");

      for (var table in tables) {
        String tableName = table['name'] as String;
        List<Map<String, dynamic>> data = await db.query(tableName);

        print("\n📊 TABLE: $tableName | Total Rows: ${data.length}");
        if (data.isEmpty) {
          print("   (Empty Table)");
        } else {
          for (var row in data) {
            print("   Row: $row");
          }
        }
      }
      print("\n**************************************************");
      print("🏁 [SQLITE DEBUG] INSPECTION COMPLETED");
      print("**************************************************\n");
    } catch (e) {
      print("❌ Error debugging database: $e");
    }
  }
  Future<void> saveTourPlans(List<dynamic> plans) async {
    final db = await instance.database;
    await db.delete('tour_plans'); // Clear old cache
    for (var plan in plans) {
      await db.insert('tour_plans', {
        'id': plan['id'],
        'data': jsonEncode(plan)
      });
    }
  }

  // Get data from local database when offline
  Future<List<dynamic>> getTourPlans() async {
    final db = await instance.database;
    final result = await db.query('tour_plans');
    return result.map((e) => jsonDecode(e['data'] as String)).toList();
  }

  // Add an action to the sync queue when user is offline
  Future<void> addToSyncQueue(String action, int? id, Map<String, dynamic>? data) async {
    final db = await instance.database;
    await db.insert('pending_sync', {
      'action_type': action,
      'tour_id': id,
      'payload': data != null ? jsonEncode(data) : null
    });
  }
  // ADD THIS METHOD INSIDE DatabaseHelper CLASS
  Future<void> syncPendingData() async {
    final online = await hasInternet();
    if (!online) return;

    final db = await DatabaseHelper.instance.database;
    final pending = await db.query('pending_sync');

    for (var item in pending) {
      final payload = jsonDecode(item['payload'] as String);

      // 🔁 Call actual API here using payload

      // After success → delete from local DB
      await db.delete(
        'pending_sync',
        where: 'id = ?',
        whereArgs: [item['id']],
      );
    }
  }
  /// --- AUTO SYNC LOGIC (Har 15-20 sec mein chalega) ---
  Future<void> saveOfflineCheckin({
    required double lat,
    required double lng,
    required int tourPlanId,
    required int visitId,
    required String convinceType,
    String? convinceText,
    double? checkIn_distance,
  }) async {
    final db = await database;
    await db.insert('offline_checkin', {
      'lat': lat,
      'lng': lng,
      'tourPlanId': tourPlanId,
      'visitId': visitId,
      'convinceType': convinceType,
      'convinceText': convinceText ?? "",
      'checkIn_distance': checkIn_distance ?? 0.0,
      'createdAt': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
    print("✅ DATA SAVED TO LOCAL DB: Check-in for Visit $visitId");
    await debugAllTablesData(); // Turant console mein check karein
  }

// Save Offline Checkout
  Future<void> saveOfflineCheckout({
    required double lat,
    required double lng,
    required int tourPlanId,
    required int visitId,
    required List<File> images,
    String? additionalInfo,
    required DateTime startDate,
  }) async {
    final db = await database;
    await db.insert('offline_checkout', {
      'lat': lat,
      'lng': lng,
      'tourPlanId': tourPlanId,
      'visitId': visitId,
      'images': jsonEncode(images.map((e) => e.path).toList()),
      'additionalInfo': additionalInfo,
      'startDate': startDate.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
    print("✅ DATA SAVED TO LOCAL DB: Check-out for Visit $visitId");
    await debugAllTablesData();
  }

// 🔄 Sequential Sync Logic
  Future<void> syncAllData() async {
    final online = await hasInternet();
    if (!online) return;

    print("🔄 SYNC STARTED...");
    await debugAllTablesData(); // Sync se pehle DB status dekhein

    // 1. Pehle Check-ins sync karein
    await _syncCheckinsWithRetry();

    // 2. Phir Check-outs sync karein
    await _syncCheckoutsWithRetry();

    print("🔄 SYNC COMPLETED.");
  }

  // SONU RAJ: Added safe CheckinController handling to prevent crashes
  Future<void> _syncCheckinsWithRetry() async {
    final db = await database;

    // SONU RAJ: CheckinController ko safely get karein - agar nahi hai to create kar dein
    CheckinController controller;
    try {
      controller = Get.find<CheckinController>();
    } catch (e) {
      print("⚠️ CheckinController not found, creating new instance for sync");
      controller = Get.put(CheckinController());
    }

    final records = await db.query('offline_checkin');

    for (var item in records) {
      bool success = await controller.checkIncontroller(
        lat: (item['lat'] as num).toDouble(),
        lng: (item['lng'] as num).toDouble(),
        tourPlanId: item['tourPlanId'] as int,
        visitId: item['visitId'] as int,
        convinceType: item['convinceType'] as String,
        convinceText: item['convinceText'] as String?,
        checkIn_distance: (item['checkIn_distance'] as num?)?.toDouble(),
        isSync: true,
      );

      if (success) {
        await db.delete('offline_checkin', where: 'id = ?', whereArgs: [item['id']]);
        print("🚀 Synced Check-in ID: ${item['id']}");
      }
    }
  }

  // SONU RAJ: Added safe CheckinController handling to prevent crashes
  Future<void> _syncCheckoutsWithRetry() async {
    final db = await database;

    // SONU RAJ: CheckinController ko safely get karein - agar nahi hai to create kar dein
    CheckinController controller;
    try {
      controller = Get.find<CheckinController>();
    } catch (e) {
      print("⚠️ CheckinController not found, creating new instance for sync");
      controller = Get.put(CheckinController());
    }

    final records = await db.query('offline_checkout');

    for (var item in records) {
      // Check if check-in for this visit is still pending in local DB
      final pendingCheckin = await db.query('offline_checkin',
          where: 'visitId = ? AND tourPlanId = ?',
          whereArgs: [item['visitId'], item['tourPlanId']]);

      if (pendingCheckin.isNotEmpty) {
        print("⚠️ Skipping Checkout ID ${item['id']} - Check-in still pending.");
        continue;
      }

      try {
        final paths = jsonDecode(item['images'] as String) as List;
        final images = paths.map<File>((p) => File(p as String)).toList();

        bool success = await controller.CheckoutController(
          lat: (item['lat'] as num).toDouble(),
          lng: (item['lng'] as num).toDouble(),
          tourPlanId: item['tourPlanId'] as int,
          visitId: item['visitId'] as int,
          images: images,
          additionalInfo: item['additionalInfo'] as String?,
          startDate: DateTime.parse(item['startDate'] as String),
          isSync: true,
        );

        if (success) {
          await db.delete('offline_checkout', where: 'id = ?', whereArgs: [item['id']]);
          print("🚀 Synced Checkout ID: ${item['id']}");
        }
      } catch (e) {
        print("❌ Sync Checkout Error: $e");
      }
    }
  }
}