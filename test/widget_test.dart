import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:duit_aman/main.dart';
import 'package:duit_aman/presentation/screens/onboarding/set_initial_budget_screen.dart';
import 'package:duit_aman/core/state/app_state.dart';

void main() {
  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('menampilkan login screen saat aplikasi pertama kali dibuka', (tester) async {
    await tester.pumpWidget(const DuitAmanApp());
    await tester.pumpAndSettle();

    expect(find.text('DuitAman v1.0'), findsOneWidget);
    expect(find.text('Selamat Datang\nKembali'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('menampilkan halaman set budget awal dengan benar', (tester) async {
    final state = AppState();
    await tester.pumpWidget(
      DuitAmanApp(
        home: SetInitialBudgetScreen(state: state),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Atur Budget Awalmu'), findsOneWidget);
    expect(find.text('KATEGORI PENGELUARAN'), findsOneWidget);
  });
}
