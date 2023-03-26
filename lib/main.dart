import 'package:baldy_dash_app/service/app_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:baldy_dash_app/common_libs.dart';
import 'package:baldy_dash_app/ux/page/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(BaldyDashApp());
  await AppService().bootstrap();

  FlutterNativeSplash.remove();
}

class BaldyDashApp extends StatelessWidget {
  const BaldyDashApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baldy Dash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
