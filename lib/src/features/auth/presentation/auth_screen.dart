import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/auth_repository.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_outlined_button.dart';
import '../../../core/widgets/app_text_field.dart';

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
  bool _isPasswordVisible = false;

  bool get _anyLoading => _isEmailLoading || _isGoogleLoading;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    if (_anyLoading) return;
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isEmailLoading = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (_isLogin) {
        await ref
            .read(authRepositoryProvider)
            .signInWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text,
            );
      } else {
        await ref
            .read(authRepositoryProvider)
            .createUserWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text,
              _nameController.text.trim(),
            );
      }
    } catch (e, stackTrace) {
      if (mounted) _handleError(e, stackTrace);
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (e, stackTrace) {
      if (mounted) _handleError(e, stackTrace);
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    // For Developer: Detailed log
    log('Auth Error', error: error, stackTrace: stackTrace, name: 'AuthScreen');

    // For User: Friendly message
    String message = 'An unexpected error occurred. Please try again.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'email-already-in-use':
          message = 'This email is already associated with another account.';
          break;
        case 'weak-password':
          message = 'The password must be at least 6 characters.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your internet connection.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled. Please contact support.';
          break;
        case 'operation-not-allowed':
          message = 'This sign-in method is currently unavailable.';
          break;
        case 'account-exists-with-different-credential':
          message =
              'An account already exists with the same email address but different sign-in credentials.';
          break;
        default:
          // Use the message from Firebase if it's somewhat readable, otherwise generic
          if (error.message != null && error.message!.isNotEmpty) {
            message = error.message!;
          }
      }
    } else {
      // Fallback for non-Firebase errors
      final errStr = error.toString().replaceAll('Exception: ', '');
      if (errStr.isNotEmpty) message = errStr;
    }

    _showSnack(message, isError: true);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) _showSnack('Could not launch $url', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define the darker border color here for reuse
    final dimmerBorderColor = colorScheme.outline.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'By continuing, you agree to RapidVal\'s ',
                ),
                TextSpan(
                  text: 'Terms',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _launchUrl('https://rapidval.web.app/privacy.html'),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Policy',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _launchUrl('https://rapidval.web.app/privacy.html'),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isLogin ? 'Welcome Back' : 'Create Account',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        height: 1.0,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.1),

                    const SizedBox(height: 8),

                    Text(
                      _isLogin
                          ? 'Sign in to continue learning.'
                          : 'Join us and start your journey.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 32),

                    if (!_isLogin)
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        enabled: !_anyLoading,
                        validator: (v) => v!.isEmpty ? 'Name required' : null,
                      ),

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_anyLoading,
                      validator: (v) =>
                          !v!.contains('@') ? 'Invalid email' : null,
                    ),

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      enabled: !_anyLoading,
                      onSubmit: _anyLoading ? null : _submit,
                      validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                      suffix: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    AppButton(
                      onPressed: _anyLoading ? null : _submit,
                      isLoading: _isEmailLoading,
                      text: _isLogin ? 'Sign In' : 'Sign Up',
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(child: Divider(color: dimmerBorderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12, // Reduced font size
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: dimmerBorderColor)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google Button - Using the darker border color
                    AppOutlinedButton(
                      onPressed: _anyLoading ? null : _signInWithGoogle,
                      isLoading: _isGoogleLoading,
                      icon: SvgPicture.asset(
                        'assets/images/google_icon.svg',
                        height: 20,
                        width: 20,
                      ),
                      text: 'Continue with Google',
                    ),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: _toggleAuthMode,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: _isLogin
                                  ? "No account? "
                                  : "Have an account? ",
                            ),
                            TextSpan(
                              text: _isLogin ? "Sign up" : "Log in",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
}
