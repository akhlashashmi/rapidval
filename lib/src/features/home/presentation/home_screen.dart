import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidval/src/core/widgets/custom_app_bar.dart';
import 'package:rapidval/src/features/auth/data/auth_repository.dart';
import 'package:rapidval/src/features/history/presentation/history_filter_provider.dart';
import 'package:rapidval/src/features/history/presentation/widgets/history_filter_bar.dart';
import 'package:rapidval/src/features/dashboard/presentation/dashboard_stats_provider.dart';
import 'package:rapidval/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:rapidval/src/features/history/presentation/history_screen.dart';
import 'package:rapidval/src/features/history/presentation/history_selection_provider.dart';
import 'package:rapidval/src/features/quiz/data/quiz_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({required this.navigationShell, super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TextEditingController _searchController;

  late final AnimationController _animController;
  late final Animation<double> _widthFactorAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _contentFadeAnimation;
  late final Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
    _searchController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
    );

    // Material 3 Emphasized Decelerate for a premium feel
    const curve = Curves.easeInOutCubicEmphasized;

    _widthFactorAnimation = CurvedAnimation(
      parent: _animController,
      curve: curve,
    );

    _titleFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-0.1, 0.0)).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
          ),
        );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0.05, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) {
      _pageController.animateToPage(
        widget.navigationShell.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    _closeSearchIfOpen(index);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _onTap(int index) {
    _closeSearchIfOpen(index);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _closeSearchIfOpen(int index) {
    if (index == 0 && _animController.isCompleted) {
      _toggleSearch();
    }
  }

  void _toggleSearch() {
    if (_animController.isCompleted) {
      _animController.reverse().then((_) {
        _searchController.clear();
        ref.read(historyFilterProvider.notifier).setSearchQuery('');
      });
    } else {
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authRepositoryProvider).currentUser;
    final currentIndex = widget.navigationShell.currentIndex;
    final selectionState = ref.watch(historySelectionProvider);
    final isSelectionMode = selectionState.isNotEmpty && currentIndex == 1;

    final currentQuery = ref.watch(historyFilterProvider).searchQuery;
    if (_searchController.text != currentQuery) {
      _searchController.text = currentQuery;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    Widget titleWidget;
    if (currentIndex == 0) {
      titleWidget = Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: colorScheme.onSurface,
          letterSpacing: -0.5,
          height: 1.2,
        ),
      );
    } else if (isSelectionMode) {
      titleWidget = Row(
        children: [
          IconButton(
            onPressed: () =>
                ref.read(historySelectionProvider.notifier).clear(),
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(width: 8),
          Text(
            '${selectionState.length} Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      );
    } else {
      titleWidget = LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              // As the action shrinks, constraints.maxWidth grows.
              // We want the bar to fill the available space.
              final double width =
                  constraints.maxWidth * _widthFactorAnimation.value;

              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  // 1. Title
                  FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: SlideTransition(
                      position: _titleSlideAnimation,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quiz History',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. Search Bar
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 52,
                      width: width,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          if (_animController.value > 0.1)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: _animController.value > 0.05
                          ? ClipRect(
                              child: OverflowBox(
                                minWidth: constraints.maxWidth,
                                maxWidth: constraints.maxWidth,
                                alignment: Alignment.centerRight,
                                child: FadeTransition(
                                  opacity: _contentFadeAnimation,
                                  child: SlideTransition(
                                    position: _contentSlideAnimation,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: HistoryFilterBar(
                                            searchController: _searchController,
                                            onSearchChanged: (value) {
                                              ref
                                                  .read(
                                                    historyFilterProvider
                                                        .notifier,
                                                  )
                                                  .setSearchQuery(value);
                                            },
                                            onFilterSelected: (value) {
                                              if (value == 'clear') {
                                                ref
                                                    .read(
                                                      historyFilterProvider
                                                          .notifier,
                                                    )
                                                    .clearFilters();
                                              } else if (value.startsWith(
                                                'diff_',
                                              )) {
                                                final diff = value.substring(5);
                                                final currentDiff = ref
                                                    .read(historyFilterProvider)
                                                    .selectedDifficulty;
                                                ref
                                                    .read(
                                                      historyFilterProvider
                                                          .notifier,
                                                    )
                                                    .setDifficulty(
                                                      currentDiff == diff
                                                          ? null
                                                          : diff,
                                                    );
                                              } else if (value.startsWith(
                                                'cat_',
                                              )) {
                                                final cat = value.substring(4);
                                                ref
                                                    .read(
                                                      historyFilterProvider
                                                          .notifier,
                                                    )
                                                    .toggleCategory(cat);
                                              }
                                            },
                                            onClose: _toggleSearch,
                                            selectedDifficulty: ref
                                                .watch(historyFilterProvider)
                                                .selectedDifficulty,
                                            selectedCategories: ref
                                                .watch(historyFilterProvider)
                                                .selectedCategories,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: titleWidget,
        subtitle: '',
        trailing: isSelectionMode
            ? IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Quizzes?'),
                      content: Text(
                        'Are you sure you want to delete ${selectionState.length} selected quizzes? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final ids = selectionState.toList();
                            await ref
                                .read(quizRepositoryProvider)
                                .deleteQuizzes(ids);

                            ref.invalidate(quizHistoryProvider);
                            ref.invalidate(recentQuizResultsProvider);
                            ref.invalidate(dashboardStatsProvider);

                            ref.read(historySelectionProvider.notifier).clear();
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.onSurface,
                ),
              )
            : currentIndex == 1
            ? AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return SizeTransition(
                    sizeFactor: ReverseAnimation(_animController),
                    axis: Axis.horizontal,
                    axisAlignment: -1.0,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    widthFactor: 1.0,
                    child: GestureDetector(
                      onTap: _toggleSearch,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.search_rounded,
                            color: colorScheme.onSurfaceVariant,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: UserAvatar(user: user, radius: 22)),
              ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [DashboardScreen(), HistoryScreen()],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Theme(
          data: theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.grid_view_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.grid_view_rounded),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.quiz_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.quiz_rounded),
                ),
                label: 'Quizzes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
