// GENERATED CODE - DO NOT MODIFY BY HAND
// Scaffolded for VAYRO Drift SQLite Foundation

part of 'local_database.dart';

// ignore_for_file: type=lint
abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $DevHealthRecordsTable get devHealthRecords => $DevHealthRecordsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [devHealthRecords];
}

class $DevHealthRecordsTable extends DevHealthRecords with TableInfo<DevHealthRecords, DevHealthRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevHealthRecordsTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsURL('PRIMARY KEY AUTOINCREMENT'));

  static const VerificationMeta _checkTypeMeta = const VerificationMeta('checkType');
  late final GeneratedColumn<String> checkType = GeneratedColumn<String>(
      'check_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);

  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);

  static const VerificationMeta _detailsMeta = const VerificationMeta('details');
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false);

  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);

  @override
  List<GeneratedColumn> get $columns => [id, checkType, status, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dev_health_records';

  @override
  VerificationContext validateIntegrity(Insertable<DevHealthRecordData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('check_type')) {
      context.handle(_checkTypeMeta, checkType.isAcceptableOrUnknown(data['check_type']!, _checkTypeMeta));
    } else if (isInserting) {
      context.missing(_checkTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta, details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DevHealthRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DevHealthRecordData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      checkType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}check_type'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      details: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DevHealthRecordsTable createAlias(String alias) {
    return $DevHealthRecordsTable(attachedDatabase, alias);
  }
}

class DevHealthRecordData extends DataClass implements Insertable<DevHealthRecordData> {
  final int id;
  final String checkType;
  final String status;
  final String? details;
  final DateTime createdAt;
  const DevHealthRecordData(
      {required this.id,
      required this.checkType,
      required this.status,
      this.details,
      required this.createdAt});

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['check_type'] = Variable<String>(checkType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'checkType': serializer.toJson<String>(checkType),
      'status': serializer.toJson<String>(status),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DevHealthRecordData copyWith(
          {int? id,
          String? checkType,
          String? status,
          Value<String?> details = const Value.absent(),
          DateTime? createdAt}) =>
      DevHealthRecordData(
        id: id ?? this.id,
        checkType: checkType ?? this.checkType,
        status: status ?? this.status,
        details: details.present ? details.value : this.details,
        createdAt: createdAt ?? this.createdAt,
      );
}

