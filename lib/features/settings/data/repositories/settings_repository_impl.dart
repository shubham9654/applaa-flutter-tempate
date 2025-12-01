import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/settings_entity.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<SettingsEntity> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) {
    return localDataSource.saveSettings(settings);
  }
}

