#!/usr/bin/env bash


#  HOW TO USE
# 
#  Add the following to a GitHub Actions 
#  workflow file (yml or yaml):
#
#    - name: Run automatic changelog
#      run: ./script/auto_changelog.sh 
# -------------------------------------------
#  On release session add:
#
#  with:
#      body_path: ./auto_changelog.txt   
#
# -------------------------------------------
#  example:  
#
#    - name: Run automatic changelog
#      run: ./script/auto-changelog.sh 
#    
#    - name: Create Release
#      uses: softprops/action-gh-release@v2
#      if: startsWith(github.ref, 'refs/tags/')
#      with:
#        body_path: ./auto_changelog.txt    

CHANGELOG_FILE="CHANGELOG.md"

{
    echo "## Changelog" 
    echo ""
    echo "> Auto-generated from CHANGELOG.md"

} > auto_changelog.txt

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
