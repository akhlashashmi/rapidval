import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_selection_provider.g.dart';

@riverpod
class HistorySelection extends _$HistorySelection {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void clear() {
    state = {};
  }

  void selectAll(List<String> ids) {
    state = {...ids};
  }
}
