#!/bin/bash
set -e

# Verificar se há commits suficientes
commit_count=$(git rev-list --count HEAD)
if [ "$commit_count" -lt 2 ]; then
    echo "There are not enough commits to compare." > auto_changelog.txt
    exit 0
fi

# Encontrar o commit anterior ao último
previous_commit=$(git rev-parse HEAD~1)

# Encontrar o caminho do arquivo CHANGELOG.md no último commit
current_file_path=$(git ls-tree -r HEAD --name-only | grep -i 'CHANGELOG.md')

# Encontrar o caminho do arquivo CHANGELOG.md no commit anterior
previous_file_path=$(git ls-tree -r $previous_commit --name-only | grep -i 'CHANGELOG.md')

# Verificar se o arquivo existe no último commit
if [ -n "$current_file_path" ]; then
    # Verificar se o arquivo também existe no commit anterior
    if [ -n "$previous_file_path" ]; then
        # Comparar o arquivo CHANGELOG.md entre o último commit e o commit anterior
        git diff --unified=0 $previous_commit HEAD -- "$current_file_path" | awk '/^\+|^-/' | sed -e 's/^[+-]//' | sed '1,2d' > auto_changelog.txt
    else
        echo "CHANGELOG.md file not found in previous commit." > auto_changelog.txt
    fi
else
    echo "CHANGELOG.md file not found in last commit." > auto_changelog.txt
fi
