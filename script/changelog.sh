#!/usr/bin/env bash


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
        git diff --unified=0 $previous_commit HEAD -- "$current_file_path" | awk '/^\+|^-/' | sed -e 's/^[+-]//' | sed '1,2d'  > auto_changelog.txt
    else
        echo "Arquivo CHANGELOG.md não encontrado no commit anterior."
        echo "" > auto_changelog.txt
    fi
else
    echo "Arquivo CHANGELOG.md não encontrado no último commit."
     echo "" > auto_changelog.txt
fi

