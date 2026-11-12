import 'package:equatable/equatable.dart';

/// Core User entity representing authenticated traveler.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.avatarUrl,
    this.role = 'USER',
    this.isActive = true,
  });

  final String id;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String role;
  final bool isActive;

  @override
  List<Object?> get props => [id, email, displayName, phoneNumber, avatarUrl, role, isActive];
}
