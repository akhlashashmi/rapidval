import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/user_controller.dart';
import '../../../core/widgets/app_button.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  final bool isSettingsMode;

  const CategorySelectionScreen({super.key, this.isSettingsMode = false});

  @override
  ConsumerState<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState
    extends ConsumerState<CategorySelectionScreen> {
  final List<String> _selectedTopics = [];
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isSettingsMode && !_isInitialized) {
      final userProfile = ref.read(userProfileProvider).value;
      if (userProfile != null) {
        _selectedTopics.addAll(
          userProfile.selectedCategories.map(_fromSnakeCase),
        );
      }
      _isInitialized = true;
    }
  }

  String _fromSnakeCase(String text) {
    return text.replaceAll('_', ' ');
  }

  void _addTopic() {
    final text = _topicController.text;
    if (text.trim().isEmpty) return;

    // Split by comma, trim each part, and filter out empty strings
    final topics = text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    bool changed = false;
    bool limitReached = false;

    for (final topic in topics) {
      if (_selectedTopics.length >= 8) {
        limitReached = true;
        break;
      }

      // Case-insensitive check for duplicates
      final isDuplicate = _selectedTopics.any(
        (t) => t.toLowerCase() == topic.toLowerCase(),
      );

      if (!isDuplicate) {
        _selectedTopics.add(topic);
        changed = true;
      }
    }

    if (changed) {
      setState(() {
        _topicController.clear();
      });
    }

    if (limitReached) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can add up to 8 topics only.')),
        );
      }
    } else if (!changed && topics.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Topic(s) already added.')),
        );
      }
    }
  }

  void _removeTopic(String topic) {
    setState(() {
      _selectedTopics.remove(topic);
    });
  }

  String _toSnakeCase(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  Future<void> _submit() async {
    if (_selectedTopics.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 5 topics.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        final formattedTopics = _selectedTopics.map(_toSnakeCase).toList();

        await ref
            .read(userRepositoryProvider)
            .updateCategories(user.uid, formattedTopics);

        if (mounted) {
          if (widget.isSettingsMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Topics updated successfully')),
            );
            context.pop();
          } else {
            context.go('/dashboard');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving preferences: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.isSettingsMode ? 'Manage Topics' : 'Your Interests'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isSettingsMode
                    ? 'Edit your interests'
                    : 'What do you want to learn?',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add 5 to 8 topics to personalize your experience. You can add multiple topics separated by commas.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Input Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _topicController,
                      style: GoogleFonts.outfit(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'e.g. Flutter, History, Science',
                        hintStyle: GoogleFonts.outfit(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest
                            .withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: (_) => _addTopic(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: _addTopic,
                    icon: const Icon(Icons.add_rounded, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(56, 56),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Topics List (Custom View)
              Expanded(
                child: _selectedTopics.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_outlined,
                              size: 48,
                              color: colorScheme.primary.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your topics will appear here',
                              style: GoogleFonts.outfit(
                                color: colorScheme.onSurfaceVariant.withOpacity(
                                  0.5,
                                ),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _selectedTopics.map((topic) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    topic,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => _removeTopic(topic),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_selectedTopics.length}',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _selectedTopics.length >= 5
                          ? colorScheme.primary
                          : colorScheme.error,
                    ),
                  ),
                  Text(
                    ' / 8 topics added',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AppButton(
                onPressed: _submit,
                isLoading: _isLoading,
                text: widget.isSettingsMode ? 'Save Changes' : 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
