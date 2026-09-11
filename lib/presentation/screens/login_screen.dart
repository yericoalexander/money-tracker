import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_palette.dart';
import 'onboarding/set_initial_budget_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.state});

  final AppState state;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _proceed(bool toOnboarding) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isNotEmpty || email.isNotEmpty) {
      widget.state.updateProfileName(
        name.isNotEmpty ? name : 'Pengguna DuitAman',
        email.isNotEmpty ? email : 'user@duitaman.id',
      );
    }

    if (toOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetInitialBudgetScreen(state: widget.state),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(state: widget.state),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppPalette.forest,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Stack(
            children: [
              // Header Background dengan nuansa forest & branding DuitAman
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * 0.38,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPalette.forest,
                        AppPalette.sage,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -20,
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 220,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppPalette.mustard.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppPalette.mustard.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  'DuitAman v1.0',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppPalette.mustard,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isRegisterMode
                                    ? 'Mulai Kelola\nKeuanganmu'
                                    : 'Selamat Datang\nKembali',
                                style: GoogleFonts.fraunces(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.paper,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isRegisterMode
                                    ? 'Daftar dan raih kebebasan finansial terencana'
                                    : 'Kelola budget bulanan dan catat pengeluaran harian',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppPalette.mist.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form Sheet Card di bagian bawah
              Positioned.fill(
                top: size.height * 0.32,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppPalette.paper,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Floating Brand Icon Badge
                      Positioned(
                        top: -24,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppPalette.forest,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppPalette.paper, width: 3.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.savings_rounded,
                              color: AppPalette.mustard,
                              size: 26,
                            ),
                          ),
                        ),
                      ),

                      // Form Body
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 38, 24, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_isRegisterMode) ...[
                              Text(
                                'Nama Lengkap',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.ink,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: _nameController,
                                hintText: 'Masukkan nama Anda',
                                prefixIcon: Icons.person_outline_rounded,
                              ),
                              const SizedBox(height: 14),
                            ],

                            Text(
                              'Email',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'nama@email.com',
                              prefixIcon: Icons.mail_outline_rounded,
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Kata Sandi',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Minimal 8 karakter',
                              prefixIcon: Icons.lock_outline_rounded,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onTogglePassword: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),

                            if (!_isRegisterMode) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Lupa Sandi?',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppPalette.forest,
                                    ),
                                  ),
                                ),
                              ),
                            ] else
                              const SizedBox(height: 8),

                            const SizedBox(height: 12),

                            // Main Action Button
                            FilledButton(
                              onPressed: () =>
                                  _proceed(_isRegisterMode ? true : false),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppPalette.forest,
                                foregroundColor: AppPalette.paper,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _isRegisterMode ? 'Daftar Sekarang' : 'Masuk',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Quick Onboarding Action Button
                            OutlinedButton.icon(
                              onPressed: () => _proceed(true),
                              icon: const Icon(Icons.tune_rounded, size: 18),
                              label: const Text('Mulai Atur Budget (Onboarding)'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppPalette.forest,
                                side: const BorderSide(color: AppPalette.forest),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                const Expanded(child: Divider(color: AppPalette.line)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'atau masuk dengan',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppPalette.inkSoft,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: AppPalette.line)),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Google Login Button
                            _buildSocialButton(
                              label: 'Lanjutkan dengan Google',
                              icon: Icons.g_mobiledata_rounded,
                              iconColor: Colors.redAccent,
                              onPressed: () => _proceed(false),
                            ),
                            const SizedBox(height: 20),

                            // Toggle Mode (Login <-> Register)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isRegisterMode
                                      ? 'Sudah punya akun? '
                                      : 'Belum punya akun? ',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppPalette.inkSoft,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isRegisterMode = !_isRegisterMode;
                                    });
                                  },
                                  child: Text(
                                    _isRegisterMode
                                        ? 'Masuk di sini'
                                        : 'Daftar akun',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.forest,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPalette.line),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: GoogleFonts.inter(fontSize: 14, color: AppPalette.ink),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(fontSize: 13, color: AppPalette.inkSoft),
          prefixIcon:
              Icon(prefixIcon, size: 20, color: AppPalette.inkSoft),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppPalette.inkSoft,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppPalette.fieldFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPalette.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppPalette.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
