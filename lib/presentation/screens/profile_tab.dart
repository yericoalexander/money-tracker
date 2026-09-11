import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding/set_initial_budget_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key, required this.state});

  final AppState state;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = widget.state.currentUser;

    return Scaffold(
      backgroundColor: AppPalette.paper,
      appBar: AppBar(
        backgroundColor: AppPalette.paper,
        elevation: 0,
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppPalette.forest,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPalette.fieldFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.line),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppPalette.forest,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: GoogleFonts.fraunces(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.paper,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppPalette.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'PENGATURAN KEUANGAN',
              style: GoogleFonts.inter(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: AppPalette.forest,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: AppPalette.fieldFill,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppPalette.line),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune_rounded,
                        color: AppPalette.forest),
                    title: Text(
                      'Ubah Target Budget Bulanan',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppPalette.inkSoft),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetInitialBudgetScreen(state: widget.state),
                        ),
                      );
                    },
                  ),
                  const Divider(indent: 56, height: 1, color: AppPalette.line),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined,
                        color: AppPalette.forest),
                    title: Text(
                      'Pengingat & Notifikasi Budget',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Switch(
                      value: _notificationEnabled,
                      activeTrackColor: AppPalette.forest,
                      onChanged: (val) {
                        setState(() {
                          _notificationEnabled = val;
                        });
                      },
                    ),
                  ),
                  const Divider(indent: 56, height: 1, color: AppPalette.line),
                  ListTile(
                    leading: const Icon(Icons.cloud_sync_outlined,
                        color: AppPalette.forest),
                    title: Text(
                      'Sinkronisasi Cloud (Firebase)',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Offline First · Terakhir sinkron baru saja',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: AppPalette.inkSoft,
                      ),
                    ),
                    trailing: const Icon(Icons.check_circle_rounded,
                        size: 18, color: AppPalette.sage),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppPalette.fieldFill,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Reset Semua Data?',
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.brick,
                      ),
                    ),
                    content: Text(
                      'Semua catatan transaksi, pagu budget, dan daftar dompet akan dihapus bersih.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppPalette.ink,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.inter(color: AppPalette.inkSoft),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          widget.state.resetAllData();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua data berhasil dibersihkan'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppPalette.brick,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 40),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep_rounded, size: 18),
              label: const Text('Bersihkan Semua Data Aplikasi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppPalette.brick,
                side: const BorderSide(color: AppPalette.brick),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(state: widget.state),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Keluar dari Akun'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppPalette.inkSoft,
                side: const BorderSide(color: AppPalette.line),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
