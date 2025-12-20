import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'backup_controller.dart';
import '../domain/backup_snapshot.dart';

const double _cardHeight = 360.0;

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupAsync = ref.watch(backupStreamProvider);
    final controllerState = ref.watch(backupControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.listen(backupControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      } else if (!next.isLoading &&
          !next.hasError &&
          previous?.isLoading == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Operation successful')));
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: const Text('Backups'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(title: 'Cloud Backup'),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: backupAsync.when(
                  data: (backup) {
                    if (backup == null) {
                      return _NoBackupCard(
                        onCreate: () {
                          ref
                              .read(backupControllerProvider.notifier)
                              .createBackup();
                        },
                      );
                    }
                    return _BackupStatusCard(
                      backup: backup,
                      onOverwrite: () => _showOverwriteDialog(context, ref),
                      onRestore: () => _showRestoreDialog(context, ref),
                      onDelete: () => _showDeleteDialog(context, ref),
                    );
                  },
                  loading: () => const _ShimmerCard(),
                  error: (err, stack) => _ErrorCard(error: err.toString()),
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Information'),
              _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Backups',
                    subtitle: 'Your data is securely stored in the cloud.',
                    showChevron: false,
                  ),
                  _SettingsTile(
                    icon: Icons.security,
                    title: 'Data Privacy',
                    subtitle: 'Only you can access your backup.',
                    showChevron: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (controllerState.isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  void _showOverwriteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overwrite Backup?'),
        content: const Text(
          'This will replace your existing cloud backup with the current local data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(backupControllerProvider.notifier).createBackup();
            },
            child: const Text('Overwrite'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup'),
        content: const Text(
          'Choose how you want to restore your data:\n\n'
          'Merge: Add missing data from backup and update existing records. Keeps your local data safe.\n\n'
          'Replace: Completely wipe local data and replace it with the backup. WARNING: Local changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(backupControllerProvider.notifier)
                  .restoreBackup(merge: true);
            },
            child: const Text('Merge'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(backupControllerProvider.notifier)
                  .restoreBackup(merge: false);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Backup?'),
        content: const Text(
          'Are you sure you want to delete your cloud backup? You will not be able to restore it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(backupControllerProvider.notifier).deleteBackup();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? titleColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showChevron = true,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor ?? theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: titleColor ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: showChevron
          ? Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _NoBackupCard extends StatelessWidget {
  final VoidCallback onCreate;

  const _NoBackupCard({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Backup Found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a backup to secure your quiz history and preferences.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('Create Backup Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupStatusCard extends StatelessWidget {
  final BackupSnapshot backup;
  final VoidCallback onOverwrite;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _BackupStatusCard({
    required this.backup,
    required this.onOverwrite,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateStr = DateFormat.yMMMd().add_jm().format(backup.createdAt);

    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme
                      .primary, // Solid color for icon bg like dashboard play button
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: colorScheme.onPrimary,
                  size: 28, // Dashboard uses 28
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLOUD BACKUP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Quizzes',
                value: '${backup.metadata.quizCount}',
                icon: Icons.quiz_outlined,
              ),
              _StatItem(
                label: 'Questions',
                value: '${backup.metadata.questionCount}',
                icon: Icons.help_outline,
              ),
              _StatItem(
                label: 'Results',
                value: '${backup.metadata.resultCount}',
                icon: Icons.bar_chart_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colorScheme.outline.withValues(alpha: 0.1)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CompactActionButton(
                icon: Icons.cloud_upload_rounded,
                label: 'Overwrite',
                onTap: onOverwrite,
                color: colorScheme.primary,
              ),
              _CompactActionButton(
                icon: Icons.cloud_download_rounded,
                label: 'Restore',
                onTap: onRestore,
                color: colorScheme.secondary,
              ),
              _CompactActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                onTap: onDelete,
                color: colorScheme.error,
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isDestructive;

  const _CompactActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.1),
            foregroundColor: color,
            padding: const EdgeInsets.all(16),
            iconSize: 24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ), // Softer shape
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary.withValues(alpha: 0.7)),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Helper to create placeholder lines
    Widget placeholderBox({
      double width = double.infinity,
      double height = 16,
      double radius = 8,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Container(
          height: _cardHeight,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Shimmer
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        placeholderBox(width: 80, height: 12),
                        const SizedBox(height: 8),
                        placeholderBox(width: 140, height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats Shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      placeholderBox(width: 30, height: 16),
                      const SizedBox(height: 4),
                      placeholderBox(width: 40, height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: colorScheme.outline.withValues(alpha: 0.05)),
              const SizedBox(height: 8),
              // Actions Shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      placeholderBox(width: 40, height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1500.ms,
          color: colorScheme.surface.withValues(alpha: 0.6),
          blendMode: BlendMode.srcOver,
        );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Backup',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
