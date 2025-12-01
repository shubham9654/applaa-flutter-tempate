import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  const ProfileEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.phoneNumber,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        bio,
        phoneNumber,
        dateOfBirth,
      ];
}

