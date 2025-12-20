
print("Starting script...")
file_path = r'h:\2025_flutter_projects\rapidval\lib\src\features\quiz\presentation\results_screen.dart'

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Python lists are 0-indexed.
    # Line 746 in 1-based index is index 745.
    # Line 892 in 1-based index is index 891.
    # We want to keep lines up to index 744 (Line 745).
    # We want to remove from index 745 (Line 746) to index 892 (Line 893).
    # lines[745:893] should be removed?
    
    # 0 .. 744 (745 lines) -> lines[0] to lines[744] (Line 1 to 745)
    # 893 .. end -> Line 894 to end.
    
    new_lines = lines[:745] + lines[893:]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print(f"Successfully removed lines 746-893 from {file_path}")

except Exception as e:
    print(f"Error: {e}")
