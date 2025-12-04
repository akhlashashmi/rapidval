import 'package:flutter_riverpod/legacy.dart';

class HistoryFilterState {
  final String searchQuery;
  final String? selectedDifficulty;
  final List<String> selectedCategories;

  const HistoryFilterState({
    this.searchQuery = '',
    this.selectedDifficulty,
    this.selectedCategories = const [],
  });

  HistoryFilterState copyWith({
    String? searchQuery,
    String? selectedDifficulty,
    List<String>? selectedCategories,
  }) {
    return HistoryFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}

class HistoryFilterNotifier extends StateNotifier<HistoryFilterState> {
  HistoryFilterNotifier() : super(const HistoryFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setDifficulty(String? difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }

  void toggleCategory(String category) {
    final categories = List<String>.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedCategories: categories);
  }

  void clearFilters() {
    state = const HistoryFilterState();
  }
}

final historyFilterProvider =
    StateNotifierProvider<HistoryFilterNotifier, HistoryFilterState>((ref) {
      return HistoryFilterNotifier();
    });
