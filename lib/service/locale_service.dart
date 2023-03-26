import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baldy_dash_app/common_libs.dart';

class LocaleService {
  final Locale _defaultLocal = Locale('en');
  SettingsService settingsService;

  LocaleService(this.settingsService) {
    settingsService.settingsNotifier.addListener(_settingsChanged);
  }

  AppLocalizations? _strings;
  AppLocalizations get strings => _strings!;
  bool get isLoaded => _strings != null;
  bool get isEnglish => strings.localeName == 'en';

  Future<void> load() async {
    Locale locale = _defaultLocal;
    if (kIsWeb) {
      return; // exit early on web as [findSystemLocale] throws errors as of Dec, 2022
    }
    if (kDebugMode) {
      // locale = Locale('zh'); // uncomment to test chinese
    }
    final localeCode = settingsService.settings.locale;
    // Try and find a supported locale
    locale = Locale(localeCode.split('_')[0]);
    // Fall back to default
    if (AppLocalizations.supportedLocales.contains(locale) == false) {
      locale = _defaultLocal;
    }

    settingsService.updateLocale(locale.languageCode);
    _strings = await AppLocalizations.delegate.load(locale);
    debugPrint("locale service loaded");
  }

  void _settingsChanged() {
    loadIfChanged(Locale(settingsService.settings.locale));
  }

  Future<void> loadIfChanged(Locale locale) async {
    bool didChange = _strings?.localeName != locale.languageCode;
    if (didChange && AppLocalizations.supportedLocales.contains(locale)) {
      _strings = await AppLocalizations.delegate.load(locale);
    }
  }
}

abstract class LocaleServiceRegistry {
  LocaleService get localeService;
}

typedef LocaleServiceFactory = LocaleService Function();
