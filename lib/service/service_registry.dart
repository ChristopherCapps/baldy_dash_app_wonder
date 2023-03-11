import 'package:baldy_dash_app/service/locale_service.dart';
import 'package:baldy_dash_app/service/settings_service.dart';
import 'package:baldy_dash_app/service/ux_service.dart';
import 'package:get_it/get_it.dart';

class ServiceRegistry
    with LocaleServiceRegistry, SettingsServiceRegistry, UxServiceRegistry {
  static ServiceRegistry? _instance;

  static ServiceRegistry get I {
    if (_instance != null) {
      return _instance!;
    } else {
      throw Exception(
          "Attempt to retrieve service registry prior to initialization");
    }
  }

  static register(
      LocaleServiceFactory localeServiceFactory,
      SettingsServiceFactory settingsServiceFactory,
      UxServiceFactory uxServiceFactory) {
    _instance = ServiceRegistry(
        localeServiceFactory, settingsServiceFactory, uxServiceFactory);
  }

  final GetIt _getIt = GetIt.instance;

  ServiceRegistry(
      LocaleServiceFactory localeServiceFactory,
      SettingsServiceFactory settingsServiceFactory,
      UxServiceFactory uxServiceFactory) {
    _getIt.registerLazySingleton(localeServiceFactory);
    _getIt.registerLazySingleton(settingsServiceFactory);
    _getIt.registerLazySingleton(uxServiceFactory);
  }

  @override
  LocaleService get localeService => _getIt.get<LocaleService>();

  @override
  SettingsService get settingsService => _getIt.get<SettingsService>();

  @override
  UxService get uxService => _getIt.get<UxService>();
}
