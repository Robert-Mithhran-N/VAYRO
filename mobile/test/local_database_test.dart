import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/core/storage/local_database.dart';

void main() {
  group('VAYRO Local Database & Storage Initialization Tests', () {
    late LocalHealthRepository repository;

    setUp(() {
      repository = InMemoryHealthRepository();
    });

    tearDown(() async {
      await repository.dispose();
    });

    test('Initial repository is empty', () async {
      final records = await repository.getRecentRecords();
      expect(records, isEmpty);
    });

    test('Insert development health-check record persists correctly', () async {
      final id = await repository.insertRecord(
        checkType: 'local_sqlite_initialization',
        status: 'SUCCESS',
        details: 'Drift schema version 1 verification',
      );

      expect(id, 1);

      final records = await repository.getRecentRecords();
      expect(records.length, 1);
      expect(records.first.checkType, 'local_sqlite_initialization');
      expect(records.first.status, 'SUCCESS');
      expect(records.first.details, 'Drift schema version 1 verification');
    });

    test('Disposal marks repository inactive and blocks further operations', () async {
      await repository.dispose();
      expect(
        () => repository.insertRecord(checkType: 'test', status: 'PENDING'),
        throwsA(isA<StateError>()),
      );
    });
  });
}

