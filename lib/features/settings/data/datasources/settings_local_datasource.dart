import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/settings_entity.dart';
import '../../../../core/constants/app_constants.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsEntity> getSettings();
  Future<void> saveSettings(SettingsEntity settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<SettingsEntity> getSettings() async {
    final isDarkMode = sharedPreferences.getBool(AppConstants.themeKey) ?? false;
    final notificationsEnabled =
        sharedPreferences.getBool(AppConstants.notificationsEnabledKey) ?? true;
    final language = sharedPreferences.getString('language') ?? 'en';

    return SettingsEntity(
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
      language: language,
    );
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    await sharedPreferences.setBool(AppConstants.themeKey, settings.isDarkMode);
    await sharedPreferences.setBool(
      AppConstants.notificationsEnabledKey,
      settings.notificationsEnabled,
    );
    await sharedPreferences.setString('language', settings.language);
  }
}

