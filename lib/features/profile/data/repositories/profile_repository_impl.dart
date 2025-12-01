import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/profile_entity.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile(String userId) {
    return remoteDataSource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return remoteDataSource.updateProfile(profile);
  }
}

