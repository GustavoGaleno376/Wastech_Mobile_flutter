import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard/app_theme.dart';
import '../../helpers/snackbar_helper.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailFocusNode = FocusNode();
  bool _isLoading = false;
  bool _emailSent = false;
  bool _wasSubmitted = false;

  AutovalidateMode get _autovalidateMode =>
      _wasSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _wasSubmitted = true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _emailSent = true);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackbar('$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _emailSent
                    ? const Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF2E7D32))
                    : Icon(Icons.lock_reset_rounded, size: 80, color: AppColors.primary.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _emailSent
                    ? Column(
                        key: const ValueKey('sent'),
                        children: [
                          Text(
                            'E-mail enviado!',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 32),
                          OutlinedButton.icon(
                            onPressed: () => setState(() => _emailSent = false),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Enviar para outro e-mail'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Voltar ao login'),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey('form'),
                        children: [
                          Text(
                            'Esqueceu sua senha?',
                            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Digite seu e-mail abaixo para receber as instruções de redefinição.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: AppColors.textSecondary, height: 1.5),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleReset(),
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.red, width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.red, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe seu e-mail';
                              }
                              if (!value.contains('@')) {
                                return 'E-mail inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _isLoading ? null : _handleReset,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Enviar E-mail'),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
