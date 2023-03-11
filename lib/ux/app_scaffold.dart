import 'package:baldy_dash_app/common_libs.dart';
import 'package:baldy_dash_app/service/ux_service.dart';
import 'package:baldy_dash_app/ux/common/app_scroll_behavior.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({Key? key, required this.child, required this.uxService})
      : super(key: key);
  final Widget child;
  final UxService uxService;
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    // Listen to the device size, and update AppStyle when it changes
    _style = AppStyle(screenSize: context.sizePx);
    Animate.defaultDuration = _style.times.fast;
    uxService.handleAppSizeChanged(context.mq.size);
    return KeyedSubtree(
      key: ValueKey($styles.scale),
      child: Theme(
        data: $styles.colors.toThemeData(),
        // Provide a default texts style to allow Hero's to render text properly
        child: DefaultTextStyle(
          style: $styles.text.body,
          // Use a custom scroll behavior across entire app
          child: ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: child,
          ),
        ),
      ),
    );
  }
}

AppStyle get $styles => AppScaffold.style;
