import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;

  const SettingsEntity({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  @override
  List<Object> get props => [isDarkMode, notificationsEnabled, language];

  SettingsEntity copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return SettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

