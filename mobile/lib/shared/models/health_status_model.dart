import 'package:equatable/equatable.dart';

/// Backend health response representation.
class BackendHealthModel extends Equatable {
  const BackendHealthModel({
    required this.status,
    required this.service,
    required this.version,
    required this.timestamp,
    this.databaseStatus,
    this.redisStatus,
    this.smokeTestMessage,
    this.smokeTestRecordId,
  });

  final String status;
  final String service;
  final String version;
  final String timestamp;
  final String? databaseStatus;
  final String? redisStatus;
  final String? smokeTestMessage;
  final int? smokeTestRecordId;

  factory BackendHealthModel.fromJson(Map<String, dynamic> json) {
    return BackendHealthModel(
      status: json['status']?.toString() ?? 'unknown',
      service: json['service']?.toString() ?? 'unknown',
      version: json['version']?.toString() ?? 'unknown',
      timestamp: json['timestamp']?.toString() ?? '',
      databaseStatus: json['database']?['status']?.toString() ?? json['databaseStatus']?.toString(),
      redisStatus: json['redis']?['status']?.toString() ?? json['redisStatus']?.toString(),
      smokeTestMessage: json['smokeTest']?['message']?.toString(),
      smokeTestRecordId: json['smokeTest']?['recordId'] is int
          ? json['smokeTest']['recordId'] as int
          : (int.tryParse(json['smokeTest']?['recordId']?.toString() ?? '')),
    );
  }

  bool get isHealthy => status == 'ok';

  @override
  List<Object?> get props => [
        status,
        service,
        version,
        timestamp,
        databaseStatus,
        redisStatus,
        smokeTestMessage,
        smokeTestRecordId,
      ];
}

