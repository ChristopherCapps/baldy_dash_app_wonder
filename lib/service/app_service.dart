import 'package:baldy_dash_app/service/ux_service.dart';
import 'package:desktop_window/desktop_window.dart';

import 'package:baldy_dash_app/common_libs.dart';
import 'package:baldy_dash_app/utils/platform_info.dart';

class AppService {
  UxService get _uxService => ServiceRegistry.I.uxService;

  /// Loads settings, sets up services etc.
  Future<void> bootstrap() async {
    debugPrint('bootstrap start...');

    _initializeServiceRegistry();

    _initializeUx();

    _initializeServices();
  }

  void _initializeServiceRegistry() {
    settingsServiceFactory() => SettingsService();
    localeServiceFactory() => LocaleService(ServiceRegistry.I.settingsService);
    uxServiceFactory() => UxService();

    ServiceRegistry.register(
        localeServiceFactory, settingsServiceFactory, uxServiceFactory);
  }

  Future<void> _initializeUx() async {
    // Set min-sizes for desktop apps
    if (PlatformInfo.isDesktop) {
      await DesktopWindow.setMinWindowSize(_uxService.styles.sizes.minAppSize);
    }

    // // Load any bitmaps the views might need
    // await AppBitmaps.init();

    // Set preferred refresh rate to the max possible (the OS may ignore this)
    // if (PlatformInfo.isAndroid) {
    //   await FlutterDisplayMode.setHighRefreshRate();
    // }
  }

  Future<void> _initializeServices() async {
    await ServiceRegistry.I.settingsService.load();
    await ServiceRegistry.I.localeService.load();
  }
}
