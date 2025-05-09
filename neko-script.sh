
#!/bin/bash

INSTALL_DIR="$HOME/.neko-script"
GITHUB_RAW_URL="https://raw.githubusercontent.com/nekoscript38/NekoScript-install/main"

function download_and_install() {
    echo "Installation de NekoScript..."

    # Créer les dossiers
    mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/libs" "$INSTALL_DIR/published_libs"

    # Installer g++ si nécessaire
    if ! command -v g++ &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y g++
    fi

    # Télécharger les fichiers sources
    echo "Téléchargement des fichiers sources..."
    curl -s -o "$INSTALL_DIR/bin/main.cpp" "$GITHUB_RAW_URL/main.cpp"
    curl -s -o "$INSTALL_DIR/bin/package_manager.cpp" "$GITHUB_RAW_URL/package_manager.cpp"

    # Compiler
    cd "$INSTALL_DIR/bin"
    g++ main.cpp -o neko-script

    # Ajouter au PATH
    echo 'export PATH="$PATH:$HOME/.neko-script/bin"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

    echo "NekoScript installé avec succès!"
}

case $1 in
    "télécharger")
        download_and_install
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
        echo "  télécharger - Installer NekoScript"
        echo "  run         - Exécuter un fichier .neko"
        echo "  publish     - Publier un package"
        echo "  librairie   - Importer un package"
        ;;
esac
