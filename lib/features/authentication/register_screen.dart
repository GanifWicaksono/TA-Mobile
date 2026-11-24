import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/user_model.dart';
import '../../core/widgets/carelink_app_bar.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neumorphic_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _caregiverNameController = TextEditingController();
  final _caregiverPhoneController = TextEditingController();

  UserRole _role = UserRole.elderly;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _caregiverNameController.dispose();
    _caregiverPhoneController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan masuk dengan akun Anda.'),
          backgroundColor: AppColors.safeMintDark,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Daftar Akun',
        subtitle: 'Lengkapi data untuk memulai monitoring',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeumorphicCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 20,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _role = UserRole.elderly),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _role == UserRole.elderly
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Lansia',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _role == UserRole.elderly
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _role = UserRole.caregiver),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _role == UserRole.caregiver
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Caregiver / Keluarga',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _role == UserRole.caregiver
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            NeumorphicTextField(
              label: 'Nama Lengkap',
              hint: _role == UserRole.elderly ? 'contoh: Bpk. Sutrisno' : 'contoh: Budi Santoso',
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: 'Nomor WhatsApp / HP',
              hint: 'contoh: 081234567890',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: 'Email',
              hint: 'contoh: nama@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: 'Kata Sandi',
              hint: 'Minimal 6 karakter',
              controller: _passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            if (_role == UserRole.elderly) ...[
              const SizedBox(height: 24),
              const Text(
                'Data Caregiver (Keluarga Terhubung)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              NeumorphicTextField(
                label: 'Nama Caregiver / Keluarga',
                hint: 'contoh: Budi Santoso (Anak)',
                controller: _caregiverNameController,
                prefixIcon: Icons.family_restroom_rounded,
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                label: 'Nomor HP Caregiver (Penerima Darurat)',
                hint: 'contoh: 081398765432',
                controller: _caregiverPhoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.contact_phone_outlined,
              ),
            ],
            const SizedBox(height: 32),
            NeumorphicButton(
              onPressed: _isLoading ? null : _handleRegister,
              variant: ButtonVariant.primary,
              height: 60,
              isFullWidth: true,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'DAFTAR SEKARANG',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
