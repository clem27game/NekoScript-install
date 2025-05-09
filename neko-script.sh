#!/bin/bash

# Définir les chemins d'installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
NEKO_LIB_DIR="$HOME/.neko-script"
BIN_DIR="$NEKO_LIB_DIR/bin"

# Créer les répertoires nécessaires
mkdir -p "$INSTALL_DIR" "$BIN_DIR"
mkdir -p "$NEKO_LIB_DIR/libs" "$NEKO_LIB_DIR/published_libs"

# Ajouter le bin au PATH
export PATH="$INSTALL_DIR:$PATH"

# Fonction pour ajouter au PATH si ce n'est pas déjà fait
add_to_path() {
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q "PATH=\"\$HOME/.local/bin:\$PATH\"" "$rc_file"; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc_file"
            fi
        fi
    done
}

if [ "$1" = "télécharger" ]; then
    echo "Installation de NekoScript..."
    
    # Copier les fichiers requis dans le répertoire d'installation
    cp "$SCRIPT_DIR/main.cpp" "$NEKO_LIB_DIR/bin/"
    cp "$SCRIPT_DIR/package_manager.cpp" "$NEKO_LIB_DIR/bin/"

    # Compiler le programme
    g++ "$NEKO_LIB_DIR/bin/main.cpp" -o "$BIN_DIR/neko-script-bin" || { echo "Erreur de compilation"; exit 1; }
    chmod +x "$BIN_DIR/neko-script-bin"
    
    # Créer un lien symbolique
    ln -sf "$BIN_DIR/neko-script-bin" "$INSTALL_DIR/neko-script"

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