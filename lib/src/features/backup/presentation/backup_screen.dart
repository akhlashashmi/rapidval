import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'backup_controller.dart';
import '../domain/backup_snapshot.dart';

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
              backupAsync.when(
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
                loading: () => const _LoadingCard(),
                error: (err, stack) => _ErrorCard(error: err.toString()),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Information'),
              _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Backups',
                    subtitle:
                        'Your data is securely stored in the cloud. You can only have one backup at a time.',
                    showChevron: false,
                  ),
                  _SettingsTile(
                    icon: Icons.security,
                    title: 'Data Privacy',
                    subtitle:
                        'Only you can access your backup. It is linked to your account.',
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
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
    final dateStr = DateFormat.yMMMd().add_jm().format(backup.createdAt);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Backup',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CompactActionButton(
                icon: Icons.cloud_upload_rounded,
                label: 'Overwrite',
                onTap: onOverwrite,
                color: theme.colorScheme.primary,
              ),
              _CompactActionButton(
                icon: Icons.cloud_download_rounded,
                label: 'Restore',
                onTap: onRestore,
                color: theme.colorScheme.secondary,
              ),
              _CompactActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                onTap: onDelete,
                color: theme.colorScheme.error,
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
            backgroundColor: isDestructive
                ? color.withValues(alpha: 0.1)
                : color.withValues(alpha: 0.1),
            foregroundColor: color,
            padding: const EdgeInsets.all(16),
            iconSize: 28,
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
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
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
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
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
