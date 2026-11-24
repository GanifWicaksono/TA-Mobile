import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/carelink_app_bar.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Lupa Kata Sandi',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: _submitted
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F7EE),
                          shape: BoxShape.circle,
                          boxShadow: AppColors.neumorphicSubtle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_rounded,
                          size: 38,
                          color: AppColors.safeMintDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tautan Reset Terkirim',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Silakan periksa kotak masuk email Anda untuk instruksi pengaturan ulang kata sandi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),
                      NeumorphicButton(
                        onPressed: () => Navigator.of(context).pop(),
                        variant: ButtonVariant.primary,
                        height: 56,
                        child: const Text('KEMBALI KE LOGIN'),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Masukkan alamat email yang terdaftar pada akun CareLink Anda untuk menerima petunjuk reset kata sandi.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    NeumorphicTextField(
                      label: 'Email Terdaftar',
                      hint: 'contoh: nama@carelink.id',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 32),
                    NeumorphicButton(
                      onPressed: _handleSubmit,
                      variant: ButtonVariant.primary,
                      height: 60,
                      isFullWidth: true,
                      child: const Text(
                        'KIRIM TAUTAN RESET',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
