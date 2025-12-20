import 'dart:io';

void main() async {
  final file = File(
    r'h:\2025_flutter_projects\rapidval\lib\src\features\quiz\presentation\results_screen.dart',
  );
  final lines = await file.readAsLines();

  // 0-indexed
  // Delete lines 746-893 (1-based) => indices 745-892

  if (lines.length < 893) {
    print('File has fewer lines than expected: ${lines.length}');
    return;
  }

  // Keep 0..744 (745 lines)
  // Skip 745..892 (148 lines?)
  // Keep 893..end

  final newLines = <String>[];
  newLines.addAll(lines.sublist(0, 745));
  newLines.addAll(lines.sublist(893));

  await file.writeAsString(newLines.join('\n'));
  print('Successfully removed lines 746-893');
}
