import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final String subtitle;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.bottom,
    this.actions,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: title,
      actions: [
        if (actions != null) ...actions!,
        if (trailing != null) trailing!,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class UserAvatar extends StatelessWidget {
  final User? user;
  final double radius;

  const UserAvatar({super.key, this.user, required this.radius});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/settings'),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: colorScheme.surfaceContainerHighest,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? Icon(
                  Icons.person,
                  color: colorScheme.onSurfaceVariant,
                  size: radius,
                )
              : null,
        ),
      ),
    );
  }
}
