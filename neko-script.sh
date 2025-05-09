#!/bin/bash

COMMAND=$1
INSTALL_DIR="$HOME/.neko-script"

function install_neko() {
    echo "Installation de nekoScript..."

    # Installation des dépendances
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs g++

    # Création des dossiers
    mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/libs" "$INSTALL_DIR/published_libs"

    # Téléchargement des fichiers sources depuis GitHub
    curl -o "$INSTALL_DIR/bin/main.cpp" https://raw.githubusercontent.com/clem27game/NekoScript-install/main/main.cpp
    curl -o "$INSTALL_DIR/bin/package_manager.cpp" https://raw.githubusercontent.com/clem27game/NekoScript-install/main/package_manager.cpp

    # Compilation
    cd "$INSTALL_DIR/bin"
    g++ main.cpp -o neko-script

    # Ajout au PATH
    echo 'export PATH="$PATH:$HOME/.neko-script/bin"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

    echo "nekoScript installé avec succès!"
    echo "Redémarrez votre terminal ou exécutez 'source ~/.bashrc'"
}

case $COMMAND in
    "télécharger")
        install_neko
        ;;
    "run")
        "$INSTALL_DIR/bin/neko-script" "$2"
        ;;
    "publish")
        cp "$2" "$INSTALL_DIR/published_libs/"
        echo "Package publié: $2"
        ;;
    "librairie")
        cp "$INSTALL_DIR/published_libs/$2" "$INSTALL_DIR/libs/"
        echo "Package importé: $2"
        ;;
    *)
        echo "Usage: neko-script <commande>"
        echo "Commandes:"
        echo "  télécharger - Installer nekoScript"
        echo "  run         - Exécuter un fichier .neko"
        echo "  publish     - Publier un package"
        echo "  librairie   - Importer un package"
        ;;
esac