
#!/bin/bash

if [ ! -f "/usr/local/bin/neko-script" ]; then
    INSTALL_DIR="$HOME/.neko-script"
    GITHUB_RAW_URL="https://raw.githubusercontent.com/clem27game/NekoScript-install/main"

    echo "Installation initiale de NekoScript..."
    
    # Créer les dossiers avec les bonnes permissions
    mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/libs" "$INSTALL_DIR/published_libs"
    chmod -R 755 "$INSTALL_DIR"

    # Installer g++ si nécessaire
    if ! command -v g++ &> /dev/null; then
        echo "Installation de g++..."
        if [ "$EUID" -ne 0 ]; then
            sudo apt-get update && sudo apt-get install -y g++
        else
            apt-get update && apt-get install -y g++
        fi
    fi

    # Télécharger les fichiers sources
    echo "Téléchargement des fichiers sources..."
    sudo curl -s -o "$INSTALL_DIR/bin/main.cpp" "$GITHUB_RAW_URL/main.cpp"
    sudo curl -s -o "$INSTALL_DIR/bin/package_manager.cpp" "$GITHUB_RAW_URL/package_manager.cpp"

    # Compiler
    cd "$INSTALL_DIR/bin"
    sudo g++ main.cpp -o neko-script
    sudo chmod +x neko-script

    # Créer un lien symbolique
    sudo ln -sf "$INSTALL_DIR/bin/neko-script" /usr/local/bin/neko-script

    echo "NekoScript installé avec succès!"
    exit 0
fi

case $1 in
    "télécharger")
        echo "NekoScript est déjà installé!"
        ;;
    "run")
        if [ -z "$2" ]; then
            echo "Usage: neko-script run <fichier.neko>"
            exit 1
        fi
        "$HOME/.neko-script/bin/neko-script" "$2"
        ;;
    "publish")
        if [ -z "$2" ]; then
            echo "Usage: neko-script publish <package.neko>"
            exit 1
        fi
        cp "$2" "$HOME/.neko-script/published_libs/"
        echo "Package publié: $2"
        ;;
    "librairie")
        if [ -z "$2" ]; then
            echo "Usage: neko-script librairie <librairie.neko>"
            exit 1
        fi
        cp "$HOME/.neko-script/published_libs/$2" "$HOME/.neko-script/libs/"
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
