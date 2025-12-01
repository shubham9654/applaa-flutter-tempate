import '../entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password, String displayName);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<User?> get authStateChanges;
}

