import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rapidval/src/core/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_outlined_button.dart';
// import '../../dashboard/data/daily_quiz_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }

  void _showThemeSelectionBottomSheet(BuildContext context, WidgetRef ref) {
    final currentMode = ref.read(themeControllerProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ThemeOption(
              title: 'System Default',
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) {
                ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                context.pop();
              },
            ),
            _ThemeOption(
              title: 'Light Mode',
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) {
                ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                context.pop();
              },
            ),
            _ThemeOption(
              title: 'Dark Mode',
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) {
                ref.read(themeControllerProvider.notifier).setThemeMode(mode);
                context.pop();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAboutBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '...';
              final buildNumber = snapshot.data?.buildNumber ?? '...';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'RapidVal',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version $version ($buildNumber)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '© 2025 RapidVal AI. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: () => context.pop(),
                      text: 'Close',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeveloperProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const _DeveloperProfileSheet(),
    );
  }

  Future<void> _showUpdateNameBottomSheet(
    BuildContext context,
    String? currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    final newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Update Name',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppOutlinedButton(
                          onPressed: () => context.pop(),
                          text: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.pop(controller.text.trim());
                            }
                          },
                          text: 'Save',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (newName != null && newName != currentName) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authRepositoryProvider).updateDisplayName(newName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to update name: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showDeleteAccountBottomSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Account?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action is irreversible. All your data, including quiz history and preferences, will be lost permanently.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    onPressed: () => context.pop(true),
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    text: 'Delete Permanently',
                  ),
                  const SizedBox(height: 12),
                  AppOutlinedButton(
                    onPressed: () => context.pop(false),
                    text: 'Cancel',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully')),
          );
          context.go('/auth');
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          if (e.code == 'requires-recent-login') {
            // Check provider to decide re-auth method
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final providerId = user.providerData.first.providerId;
              if (providerId == 'password') {
                // Email/Password re-auth
                await _showReAuthenticateDialog(context);
              } else if (providerId == 'google.com') {
                // Google re-auth
                _showReLoginBottomSheet(context);
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Failed to delete account')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showReAuthenticateDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter your password to confirm account deletion.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  text: 'Cancel',
                  height: 48,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  height: 48,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext); // Close dialog
                      setState(() => _isLoading = true);
                      try {
                        final email = FirebaseAuth.instance.currentUser?.email;
                        if (email != null) {
                          final credential = EmailAuthProvider.credential(
                            email: email,
                            password: passwordController.text,
                          );
                          await FirebaseAuth.instance.currentUser
                              ?.reauthenticateWithCredential(credential);
                          await ref
                              .read(authRepositoryProvider)
                              .deleteAccount();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account deleted successfully'),
                              ),
                            );
                            context.go('/auth');
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete account: $e'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                  },
                  text: 'Confirm',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReLoginBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Security Check Required',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'For your security, deleting your account requires you to have signed in recently. Please sign out and sign in again to proceed.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () async {
                    sheetContext.pop();
                    // Sign out first
                    await ref.read(authRepositoryProvider).signOut();
                    if (mounted) {
                      try {
                        final user = await ref
                            .read(authRepositoryProvider)
                            .signInWithGoogle();
                        if (user != null) {
                          // Re-auth successful, try deleting again
                          await ref
                              .read(authRepositoryProvider)
                              .deleteAccount();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account deleted successfully'),
                              ),
                            );
                            context.go('/auth');
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Re-authentication failed: $e'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  text: 'Re-authenticate with Google',
                ),
              ),
              const SizedBox(height: 12),
              AppOutlinedButton(
                onPressed: () => sheetContext.pop(),
                text: 'Cancel',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSignOutBottomSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Sign Out?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out of your account?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      onPressed: () => context.pop(false),
                      text: 'Cancel',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      onPressed: () => context.pop(true),
                      text: 'Sign Out',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      await ref.read(authRepositoryProvider).signOut();
      if (mounted) context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      // extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account Section
                _SectionHeader(title: 'Account'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.badge_outlined,
                      title: 'Name',
                      subtitle: user?.displayName ?? 'Set a display name',
                      onTap: () => _showUpdateNameBottomSheet(
                        context,
                        user?.displayName,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: 'Email',
                      subtitle: user?.email ?? 'Not signed in',
                      showChevron: false,
                    ),
                    _SettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'Delete Account',
                      subtitle: 'Permanently remove your data',
                      titleColor: theme.colorScheme.error,
                      iconColor: theme.colorScheme.error,
                      onTap: () => _showDeleteAccountBottomSheet(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Preferences Section
                _SectionHeader(title: 'Preferences'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.category_outlined,
                      title: 'Manage Topics',
                      subtitle: 'Customize your learning interests',
                      onTap: () => context.push('/manage-topics'),
                    ),
                    _SettingsTile(
                      icon: Icons.backup_outlined,
                      title: 'Backups',
                      subtitle: 'Manage your data backups',
                      onTap: () => context.push('/backups'),
                    ),
                    _SettingsTile(
                      icon: Icons.brightness_6_outlined,
                      title: 'Theme',
                      subtitle: _getThemeModeName(
                        ref.watch(themeControllerProvider),
                      ),
                      onTap: () => _showThemeSelectionBottomSheet(context, ref),
                    ),
                    // _SettingsTile(
                    //   icon: Icons.alarm_rounded,
                    //   title: 'Reminders',
                    //   subtitle: 'Daily study reminders',
                    //   trailing: Switch(value: true, onChanged: (val) {}),
                    // ),
                    // _SettingsTile(
                    //   icon: Icons.refresh_rounded,
                    //   title: 'Refresh Daily Quiz',
                    //   subtitle: 'Generate a new daily challenge',
                    //   onTap: () async {
                    //     setState(() => _isLoading = true);
                    //     try {
                    //       await ref
                    //           .read(dailyQuizRepositoryProvider)
                    //           .refreshDailyQuiz();
                    //       // Invalidate the provider to force a refresh on the dashboard
                    //       ref.invalidate(dailyQuizProvider);
                    //       if (context.mounted) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //             content: Text('Daily quiz refreshed!'),
                    //           ),
                    //         );
                    //       }
                    //     } catch (e) {
                    //       if (context.mounted) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text('Failed to refresh: $e')),
                    //         );
                    //       }
                    //     } finally {
                    //       if (mounted) setState(() => _isLoading = false);
                    //     }
                    //   },
                    // ),
                  ],
                ),

                const SizedBox(height: 24),

                // Support Section
                _SectionHeader(title: 'Support & About'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.code_rounded,
                      title: 'Developer Info',
                      subtitle: 'Meet the creator',
                      onTap: () => _showDeveloperProfileBottomSheet(context),
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About RapidVal',
                      subtitle: 'App version and information',
                      onTap: () => _showAboutBottomSheet(context),
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () {
                        context.push('/privacy-policy');
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms of service',
                      onTap: () {
                        context.push('/terms-of-service');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Sign Out',
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurfaceVariant,
                  onPressed: () => _showSignOutBottomSheet(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;
  // final Widget? trailing;
  final bool showChevron;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
    this.iconColor,
    // this.trailing,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor ?? theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: titleColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // if (trailing != null)
            //   trailing!
            // else if (showChevron && onTap != null)
            if (showChevron && onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Radio<ThemeMode>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(value),
            ),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _DeveloperProfileSheet extends StatelessWidget {
  const _DeveloperProfileSheet();

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Avatar with subtle glow
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: colorScheme.primaryContainer,
                foregroundImage: AssetImage(
                  'assets/images/developer_image.png',
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 45,
                  color: colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Name & Title
            Text(
              'Akhlas Ahmed',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Flutter Engineer',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Bio
            Text(
              'Passionate about crafting robust, scalable, and beautiful mobile experiences. Leveraging the power of Dart and AI to solve complex problems.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),
            Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
            const SizedBox(height: 24),

            // 4. Social Actions
            Text(
              'Connect with me',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.linkedinIn,
                  color: const Color(0xFF0077B5),
                  onTap: () => _launchUrl(
                    context,
                    'https://www.linkedin.com/in/akhlashashmi',
                  ),
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: FontAwesomeIcons.globe,
                  color: colorScheme.primary,
                  onTap: () =>
                      _launchUrl(context, 'https://akhlasahmed.online/'),
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: FontAwesomeIcons.github,
                  color: colorScheme.onSurface,
                  onTap: () =>
                      _launchUrl(context, 'https://github.com/akhlashashmi'),
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  icon: Icons.email_rounded,
                  color: const Color(0xFFEA4335),
                  onTap: () =>
                      _launchUrl(context, 'mailto:akhlasahmed.aka@gmail.com'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _SocialButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
