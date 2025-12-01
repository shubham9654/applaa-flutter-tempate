import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('Profile not found');
      }

      final data = doc.data()!;
      final user = FirebaseAuth.instance.currentUser;

      return ProfileEntity(
        id: userId,
        email: user?.email ?? data['email'] ?? '',
        displayName: data['displayName'] ?? user?.displayName,
        photoUrl: data['photoUrl'] ?? user?.photoURL,
        bio: data['bio'],
        phoneNumber: data['phoneNumber'],
        dateOfBirth: data['dateOfBirth']?.toDate(),
      );
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await firestore.collection('users').doc(profile.id).update({
        'displayName': profile.displayName,
        'bio': profile.bio,
        'phoneNumber': profile.phoneNumber,
        'dateOfBirth': profile.dateOfBirth,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update Firebase Auth display name
      if (profile.displayName != null) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(
          profile.displayName,
        );
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

