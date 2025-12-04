import 'package:flutter/material.dart';
import 'package:rapidval/src/features/quiz/domain/quiz_category.dart';

class HistoryFilterBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;
  final VoidCallback onClose;
  final String? selectedDifficulty;
  final List<String> selectedCategories;
  final EdgeInsetsGeometry? padding;

  const HistoryFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterSelected,
    required this.onClose,
    this.selectedDifficulty,
    required this.selectedCategories,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeFiltersCount =
        (selectedDifficulty != null ? 1 : 0) + selectedCategories.length;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: colorScheme.primary,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search history...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: theme.copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  tooltip: 'Filter Options',
                  offset: const Offset(0, 8),
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  constraints: const BoxConstraints(
                    maxWidth: 320,
                    minWidth: 280,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  color: colorScheme.surfaceContainerLow,
                  surfaceTintColor: colorScheme.secondaryContainer,
                  icon: Badge(
                    isLabelVisible: activeFiltersCount > 0,
                    label: Text('$activeFiltersCount'),
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    smallSize: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      enabled: false,
                      padding: EdgeInsets.zero,
                      child: _CompactFilterMenu(
                        selectedDifficulty: selectedDifficulty,
                        selectedCategories: selectedCategories,
                        onFilterSelected: onFilterSelected,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, size: 22),
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CompactFilterMenu extends StatefulWidget {
  final String? selectedDifficulty;
  final List<String> selectedCategories;
  final ValueChanged<String> onFilterSelected;

  const _CompactFilterMenu({
    required this.selectedDifficulty,
    required this.selectedCategories,
    required this.onFilterSelected,
  });

  @override
  State<_CompactFilterMenu> createState() => _CompactFilterMenuState();
}

class _CompactFilterMenuState extends State<_CompactFilterMenu> {
  // Local state for immediate UI feedback
  late String? _difficulty;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.selectedDifficulty;
    _categories = List.from(widget.selectedCategories);
  }

  void _toggleDifficulty(String diff) {
    setState(() {
      _difficulty = (_difficulty == diff) ? null : diff;
    });
    // Add a slight delay to allow the ink splash to show before the popup might close
    // (though in this case we want the popup to stay open usually)
    widget.onFilterSelected('diff_$diff');
  }

  void _toggleCategory(String cat) {
    setState(() {
      if (_categories.contains(cat)) {
        _categories.remove(cat);
      } else {
        _categories.add(cat);
      }
    });
    widget.onFilterSelected('cat_$cat');
  }

  void _clearAll() {
    setState(() {
      _difficulty = null;
      _categories.clear();
    });
    widget.onFilterSelected('clear');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Header ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_difficulty != null || _categories.isNotEmpty)
                    IconButton(
                      onPressed: _clearAll,
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      tooltip: 'Reset filters',
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),

          // --- Difficulty Section ---
          _SectionHeader(title: 'Difficulty'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Beginner', 'Intermediate', 'Advanced'].map((diff) {
              return _FilterChip(
                label: diff,
                isSelected: _difficulty == diff,
                onTap: () => _toggleDifficulty(diff),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // --- Categories Section ---
          _SectionHeader(title: 'Categories'),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: QuizCategory.values.map((cat) {
                  return _FilterChip(
                    label: cat.displayName,
                    isSelected: _categories.contains(cat.displayName),
                    onTap: () => _toggleCategory(cat.displayName),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets for Cleaner Code ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.secondaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
