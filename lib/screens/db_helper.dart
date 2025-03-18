import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // สร้าง singleton pattern
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'game_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // สร้างตาราง game_records
    await db.execute('''
      CREATE TABLE game_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        home_team TEXT NOT NULL,
        guest_team TEXT NOT NULL,
        home_score INTEGER NOT NULL,
        guest_score INTEGER NOT NULL,
        quater_number INTEGER NOT NULL,
        quater_minutes INTEGER NOT NULL,
        total_quarters INTEGER NOT NULL,
        formatted_date TEXT NOT NULL
      )
    ''');
  }

  /// ✅ ตรวจสอบว่าตาราง game_records มีอยู่หรือไม่
  Future<bool> _checkIfTableExists() async {
    final Database db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='game_records';"
    );
    return result.isNotEmpty; // ถ้าเจอแสดงว่าตารางมีอยู่แล้ว
  }

/// ✅ แทรกข้อมูลเกม (ตรวจสอบฐานข้อมูลก่อน)
Future<int> insertGameRecord(String homeTeam, String guestTeam, int homeScore, int guestScore, int quarter, int quarterMinutes, int totalQuarters) async {
  final Database db = await database;
  print("✅ กำลังบันทึกข้อมูลลงฐานข้อมูล...game_records");
  
  // เช็กว่าตารางมีอยู่ไหม ถ้าไม่มีให้สร้างใหม่
  bool tableExists = await _checkIfTableExists();
  if (!tableExists) {
    await _onCreate(db, 1);
  }

  final DateTime now = DateTime.now();
  final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  // สร้าง map ข้อมูลที่จะบันทึก
  Map<String, dynamic> recordData = {
    'home_team': homeTeam,
    'guest_team': guestTeam,
    'home_score': homeScore,
    'guest_score': guestScore,
    'quater_number': quarter,
    'quater_minutes': quarterMinutes,
    'total_quarters': totalQuarters,
    'formatted_date': formattedDate,
  };
  
  // บันทึกข้อมูลและเก็บ ID ที่ได้
  int insertedId = await db.insert('game_records', recordData);
  
  // แสดงข้อมูลที่บันทึกแล้ว
  print("✅ บันทึกข้อมูลสำเร็จ! ID: $insertedId");
  print("📋 ข้อมูลที่บันทึก: $recordData");
  print("🏀 ทีม $homeTeam vs $guestTeam, ผลการแข่งขัน: $homeScore - $guestScore");
  print("⏱️ เล่นไป ${quarter + 1} ควอเตอร์, จาก $totalQuarters ควอเตอร์, ควอเตอร์ละ $quarterMinutes นาที");
  print("📅 บันทึกเมื่อ: $formattedDate");
  
  return insertedId;
}

  /// ✅ ดึงข้อมูลทั้งหมด
  Future<List<Map<String, dynamic>>> getAllGameRecords() async {
    final Database db = await database;
    return await db.query('game_records', orderBy: 'formatted_date DESC');
  }


// ฟังก์ชันลบข้อมูลเกมจากฐานข้อมูล
Future<int> deleteGameRecord(int id) async {
  final Database db = await database;
  print("🗑️ กำลังลบข้อมูลเกม ID: $id จากฐานข้อมูล...");
  
  try {
    // ลบข้อมูลที่มี id ตรงกับที่ระบุ
    int result = await db.delete(
      'game_records', 
      where: 'id = ?', 
      whereArgs: [id]
    );
    
    // ตรวจสอบว่าลบสำเร็จหรือไม่
    if (result > 0) {
      print("✅ ลบข้อมูลเกม ID: $id สำเร็จ");
    } else {
      print("⚠️ ไม่พบข้อมูลเกม ID: $id หรือไม่สามารถลบได้");
    }
    
    return result;
  } catch (e) {
    print("❌ เกิดข้อผิดพลาดในการลบข้อมูล: $e");
    return 0;
  }
}

// ฟังก์ชันลบข้อมูลเกมทั้งหมด (อาจใช้สำหรับฟีเจอร์ "Clear All Records")
Future<int> deleteAllGameRecords() async {
  final Database db = await database;
  print("🗑️ กำลังลบข้อมูลเกมทั้งหมดจากฐานข้อมูล...");
  
  try {
    int result = await db.delete('game_records');
    print("✅ ลบข้อมูลเกมทั้งหมดสำเร็จ จำนวน: $result รายการ");
    return result;
  } catch (e) {
    print("❌ เกิดข้อผิดพลาดในการลบข้อมูลทั้งหมด: $e");
    return 0;
  }
}
}