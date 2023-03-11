import 'package:baldy_dash_app/common_libs.dart';
import 'package:baldy_dash_app/model/settings.dart';
import 'package:baldy_dash_app/utils/file_persistence_mixin.dart';

class SettingsService with FilePersistenceMixin, ChangeNotifier {
  final _settings = ValueNotifier<Settings>(Settings());

  SettingsService() {
    _settings.addListener(scheduleSave);
  }

  Settings get settings => _settings.value;

  ValueNotifier<Settings> get settingsNotifier => _settings;

  Map<String, dynamic> _toMap() {
    return {
      'locale': settings.locale,
    };
  }

  void _fromMap(Map<String, dynamic> map) {
    _settings.value = Settings.of(
      map['locale'] ?? Settings.defaultLocale,
    );
  }

  void updateLocale(String localeCode) {
    if (settings.locale != localeCode) {
      _settings.value = Settings.of(localeCode);
    }
  }

  // Mixin impls
  @override
  String get fileName => 'settings.dat';

  @override
  Map<String, dynamic> toJson() => _toMap();

  @override
  void fromJson(Map<String, dynamic> map) => _fromMap(map);
}

abstract class SettingsServiceRegistry {
  SettingsService get settingsService;
}

typedef SettingsServiceFactory = SettingsService Function();
