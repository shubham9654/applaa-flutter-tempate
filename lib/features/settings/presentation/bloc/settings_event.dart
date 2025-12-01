part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ToggleTheme extends SettingsEvent {
  const ToggleTheme();
}

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications();
}

class ChangeLanguage extends SettingsEvent {
  final String language;

  const ChangeLanguage(this.language);

  @override
  List<Object> get props => [language];
}

