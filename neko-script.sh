
#!/bin/bash

# Définir les chemins d'installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
NEKO_LIB_DIR="$HOME/.neko-script"

# Fonction pour ajouter au PATH
add_to_path() {
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q "PATH=\"\$HOME/.local/bin:\$PATH\"" "$rc_file"; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc_file"
            fi
        fi
    done
    export PATH="$HOME/.local/bin:$PATH"
}

if [ "$1" = "télécharger" ]; then
    echo "Installation de NekoScript..."

    # Créer les dossiers nécessaires
    mkdir -p "$INSTALL_DIR" "$NEKO_LIB_DIR/bin" "$NEKO_LIB_DIR/libs" "$NEKO_LIB_DIR/published_libs"
    chmod -R 755 "$NEKO_LIB_DIR"

    # Copier les fichiers nécessaires
    cp "$SCRIPT_DIR/main.cpp" "$NEKO_LIB_DIR/bin/"
    cp "$SCRIPT_DIR/package_manager.cpp" "$NEKO_LIB_DIR/bin/"

    # Compiler le programme
    cd "$NEKO_LIB_DIR/bin"
    g++ main.cpp -o neko-script-bin
    chmod +x neko-script-bin

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

    # Ajouter au PATH
    add_to_path

    echo "NekoScript installé avec succès!"
    echo "Redémarrez votre terminal ou exécutez 'source ~/.bashrc' pour utiliser neko-script"
    exit 0
fi

# Exécuter la commande
if [ -x "$NEKO_LIB_DIR/bin/neko-script-bin" ]; then
    exec "$NEKO_LIB_DIR/bin/neko-script-bin" "$@"
else
    echo "Erreur: NekoScript n'est pas correctement installé. Utilisez 'neko-script télécharger' pour l'installer."
    exit 1
fi
