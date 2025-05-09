#!/bin/bash

# Définir les chemins d'installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
NEKO_LIB_DIR="$HOME/.neko-script"

if [ "$1" = "télécharger" ]; then
    echo "Installation de NekoScript..."

    # Créer les dossiers nécessaires
    mkdir -p "$INSTALL_DIR" "$NEKO_LIB_DIR/bin" "$NEKO_LIB_DIR/libs" "$NEKO_LIB_DIR/published_libs"
    chmod -R 755 "$NEKO_LIB_DIR"

    # Compiler le programme
    g++ "$SCRIPT_DIR/main.cpp" -o "$NEKO_LIB_DIR/bin/neko-script-bin"
    chmod +x "$NEKO_LIB_DIR/bin/neko-script-bin"

    # Créer le script wrapper
    cat > "$INSTALL_DIR/neko-script" << 'EOF'
#!/bin/bash
NEKO_LIB_DIR="$HOME/.neko-script"
case $1 in
    "télécharger") echo "NekoScript est déjà installé!" ;;
    "run") "$NEKO_LIB_DIR/bin/neko-script-bin" "$2" ;;
    "publish") cp "$2" "$NEKO_LIB_DIR/published_libs/" && echo "Package publié: $2" ;;
    "librairie") cp "$NEKO_LIB_DIR/published_libs/$2" "$NEKO_LIB_DIR/libs/" && echo "Package importé: $2" ;;
    *) "$NEKO_LIB_DIR/bin/neko-script-bin" "$@" ;;
esac
EOF

    chmod +x "$INSTALL_DIR/neko-script"

    # Ajouter au PATH si nécessaire
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        export PATH="$INSTALL_DIR:$PATH"
    fi

    echo "NekoScript installé avec succès!"
    echo "Redémarrez votre terminal ou exécutez 'source ~/.bashrc' pour utiliser neko-script"
    exit 0
fi

exec "$NEKO_LIB_DIR/bin/neko-script-bin" "$@"