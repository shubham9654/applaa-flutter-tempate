import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) {
    return remoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) {
    return remoteDataSource.signUpWithEmailAndPassword(email, password, displayName);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;
}

