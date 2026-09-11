import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const DuitAmanApp());
}

class DuitAmanApp extends StatefulWidget {
  const DuitAmanApp({super.key, this.home});

  final Widget? home;

  @override
  State<DuitAmanApp> createState() => _DuitAmanAppState();
}

class _DuitAmanAppState extends State<DuitAmanApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuitAman — Budgeting & Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: widget.home ?? LoginScreen(state: _appState),
    );
  }
}
