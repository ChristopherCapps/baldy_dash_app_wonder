import 'package:baldy_dash_app/common_libs.dart';
import 'package:baldy_dash_app/ux/app_scaffold.dart';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:baldy_dash_app/utils/platform_info.dart';

class UxService {
  /// Indicates which orientations the app will allow be default. Affects Android/iOS devices only.
  /// Defaults to both landscape (hz) and portrait (vt)
  List<Axis> supportedOrientations = [Axis.vertical, Axis.horizontal];

  /// Allow a view to override the currently supported orientations. For example, [FullscreenVideoViewer] always wants to enable both landscape and portrait.
  /// If a view sets this override, they are responsible for setting it back to null when finished.
  List<Axis>? _supportedOrientationsOverride;
  set supportedOrientationsOverride(List<Axis>? value) {
    if (_supportedOrientationsOverride != value) {
      _supportedOrientationsOverride = value;
      _updateSystemOrientation();
    }
  }

  Future<void> bootstrapUx() async {
    // Set min-sizes for desktop apps
    if (PlatformInfo.isDesktop) {
      await DesktopWindow.setMinWindowSize($styles.sizes.minAppSize);
    }

    // Load any bitmaps the views might need
    //await AppBitmaps.init();

    // Set preferred refresh rate to the max possible (the OS may ignore this)
    if (PlatformInfo.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  // Future<T?> showFullscreenDialogRoute<T>(BuildContext context, Widget child,
  //     {bool transparent = false}) async {
  //   return await Navigator.of(context).push<T>(
  //     PageRoutes.dialog<T>(child, duration: $styles.times.pageTransition),
  //   );
  // }

  /// Called from the UI layer once a MediaQuery has been obtained
  void handleAppSizeChanged(Size size) {
    /// Disable landscape layout on smaller form factors
    bool isSmall = size.shortestSide < 500 && size != Size.zero;
    supportedOrientations =
        isSmall ? [Axis.vertical] : [Axis.vertical, Axis.horizontal];
    _updateSystemOrientation();
  }

  /// Enable landscape, portrait or both. Views can call this method to override the default settings.
  /// For example, the [FullscreenVideoViewer] always wants to enable both landscape and portrait.
  /// If a view overrides this, it is responsible for setting it back to [supportedOrientations] when disposed.
  void _updateSystemOrientation() {
    final axisList = _supportedOrientationsOverride ?? supportedOrientations;
    debugPrint('updateDeviceOrientation, supportedAxis: $axisList');
    final orientations = <DeviceOrientation>[];
    if (axisList.contains(Axis.vertical)) {
      orientations.addAll([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    if (axisList.contains(Axis.horizontal)) {
      orientations.addAll([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setPreferredOrientations(orientations);
  }

  AppStyle get styles => $styles;
}

abstract class UxServiceRegistry {
  UxService get uxService;
}

typedef UxServiceFactory = UxService Function();
