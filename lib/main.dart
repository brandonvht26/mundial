import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/matches/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  await ServiceLocator.init();
  runApp(const WC26CalendarApp());
}

class WC26CalendarApp extends StatelessWidget {
  const WC26CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario FIFA WC26',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
