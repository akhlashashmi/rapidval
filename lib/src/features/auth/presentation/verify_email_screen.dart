import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import '../data/auth_repository.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isResendLoading = false;
  Timer? _checkVerifiedTimer;
  Timer? _resendCooldownTimer;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();

    // Smart Timer Logic:
    // Check if the user account was created very recently (within the last minute).
    // If so, we assume they just signed up and the auto-email was sent, so we start the timer.
    // If they restart the app later, creationTime will be older, so no timer starts.
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null && user.metadata.creationTime != null) {
      final creationTime = user.metadata.creationTime!;
      final timeSinceCreation = DateTime.now().difference(creationTime);

      if (timeSinceCreation.inSeconds < 60) {
        // Account created less than 60 seconds ago
        _countdown = 60 - timeSinceCreation.inSeconds;
        _startResendTimer();
      }
    }

    // Check verification status periodically
    _checkVerifiedTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      try {
        await ref.read(authRepositoryProvider).reloadUser();
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          if (mounted) ref.invalidate(authStateChangesProvider);
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _checkVerifiedTimer?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _countdown = 60);
    _resendCooldownTimer?.cancel();
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resend() async {
    if (_countdown > 0) return;

    setState(() => _isResendLoading = true);
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (mounted) _snack('Verification email resent');
      _startResendTimer();
    } catch (e) {
      if (mounted) _snack(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isResendLoading = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Clean light background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3ECFA), // Light blue background
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.forward_to_inbox_rounded,
                    size: 48,
                    color: Color(0xFF2B65E3), // Blue icon
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Check Your Inbox',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1C29), // Dark text
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle & Email
              Text(
                "We've sent a verification link to",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF5E6475), // Grey text
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? "your email",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1C29), // Dark text
                ),
              ),
              const SizedBox(height: 24),

              // Instruction
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text.rich(
                  TextSpan(
                    text: "Please check your ",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFF5E6475),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: "inbox",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1C29),
                        ),
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "spam folder",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1C29),
                        ),
                      ),
                      const TextSpan(text: " to\ncontinue."),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 48),

              // Resend Section
              Text(
                "Didn't receive an email?",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF5E6475),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Resend Button
              GestureDetector(
                onTap: (_countdown > 0 || _isResendLoading) ? null : _resend,
                child: _isResendLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text.rich(
                        TextSpan(
                          text: "Resend",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (_countdown > 0)
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF4B7BE5), // Blue
                          ),
                          children: [
                            if (_countdown > 0)
                              TextSpan(
                                text:
                                    " (0:${_countdown.toString().padLeft(2, '0')})",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),

              const Spacer(flex: 3),

              // Return to Sign In
              TextButton(
                onPressed: () => ref.read(authRepositoryProvider).signOut(),
                child: Text(
                  'Return to Sign In',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5E6475),
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
