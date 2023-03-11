class Settings {
  static const String defaultLocale = "en";

  final String locale;

  //final bool useBlurs = !PlatformInfo.isAndroid;

  Settings.of(this.locale);

  Settings() : this.of(defaultLocale);
}
