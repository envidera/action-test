 # Define o arquivo do changelog
CHANGELOG_FILE="CHANGELOG.md"

echo "# Changelog" > auto_changelog.txt

awk '
BEGIN { inside_section = 0; }
/^## v[0-9]+/ {
  if (inside_section == 1) {
    exit;
  }
  inside_section = 1;
  next;
}
inside_section == 1 {
  print;
}' "$CHANGELOG_FILE" >> auto_changelog.txt

ls
