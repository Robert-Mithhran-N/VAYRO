import 'dart:async';
import 'package:drift/drift.dart';

part 'local_database.g.dart';

/// Development health-check record table for verifying local persistence.
class DevHealthRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get checkType => text().withLength(min: 1, max: 64)();
  TextColumn get status => text().withLength(min: 1, max: 32)();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Core Drift database configuration for VAYRO mobile client.
@DriftDatabase(tables: [DevHealthRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future schema migrations will be handled here incrementally
        },
        beforeOpen: (details) async {
          // Enable foreign keys and WAL mode if needed
        },
      );
}

/// Domain entity representing a local health record.
class LocalHealthRecord {
  const LocalHealthRecord({
    required this.id,
    required this.checkType,
    required this.status,
    this.details,
    required this.createdAt,
  });

  final int id;
  final String checkType;
  final String status;
  final String? details;
  final DateTime createdAt;
}

/// Repository contract for local health persistence.
abstract class LocalHealthRepository {
  Future<int> insertRecord({required String checkType, required String status, String? details});
  Future<List<LocalHealthRecord>> getRecentRecords({int limit = 10});
  Future<void> clearRecords();
  Future<void> dispose();
}

/// In-memory and fallback repository for development environments and unit testing.
class InMemoryHealthRepository implements LocalHealthRepository {
  final List<LocalHealthRecord> _records = [];
  int _counter = 0;
  bool _isDisposed = false;

  @override
  Future<int> insertRecord({required String checkType, required String status, String? details}) async {
    _ensureNotDisposed();
    _counter++;
    final record = LocalHealthRecord(
      id: _counter,
      checkType: checkType,
      status: status,
      details: details,
      createdAt: DateTime.now(),
    );
    _records.insert(0, record);
    return record.id;
  }

  @override
  Future<List<LocalHealthRecord>> getRecentRecords({int limit = 10}) async {
    _ensureNotDisposed();
    return _records.take(limit).toList();
  }

  @override
  Future<void> clearRecords() async {
    _ensureNotDisposed();
    _records.clear();
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    _records.clear();
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('InMemoryHealthRepository has already been disposed.');
    }
  }
}

