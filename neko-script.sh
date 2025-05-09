
#!/bin/bash

COMMAND=$1
ARG=$2
INSTALL_DIR="$HOME/.neko-script"

function install_dependencies() {
    if ! command -v node &> /dev/null; then
        echo "Installation de Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    if ! command -v g++ &> /dev/null; then
        echo "Installation de G++..."
        sudo apt-get install -y g++
    fi
}

case $COMMAND in
  "télécharger")
    echo "Installation de nekoScript..."
    install_dependencies
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/bin"
    mkdir -p "$INSTALL_DIR/libs"
    mkdir -p "$INSTALL_DIR/published_libs"
    
    # Copie des fichiers sources
    cp main.cpp "$INSTALL_DIR/bin/"
    cp package_manager.cpp "$INSTALL_DIR/bin/"
    
    # Compilation
    cd "$INSTALL_DIR/bin"
    g++ main.cpp -o neko-script
    
    # Ajout au PATH
    echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.bashrc"
    export PATH="$PATH:$INSTALL_DIR/bin"
    
    echo "nekoScript installé avec succès!"
    echo "Redémarrez votre terminal ou exécutez 'source ~/.bashrc'"
    ;;
  "run")
    if [ -z "$ARG" ]; then
      echo "Spécifiez un fichier .neko à exécuter."
    else
      neko-script "$ARG"
    fi
    ;;
  "publish")
    if [ -z "$ARG" ]; then
      echo "Spécifiez un nom de bibliothèque à publier."
    else
      cp "$ARG" "$INSTALL_DIR/published_libs/"
      echo "Librairie $ARG publiée avec succès."
    fi
    ;;
  "librairie")
    if [ -z "$ARG" ]; then
      echo "Spécifiez une bibliothèque à importer."
    else
      cp "$INSTALL_DIR/published_libs/$ARG" "$INSTALL_DIR/libs/"
      echo "Librairie $ARG importée avec succès."
    fi
    ;;
  *)
    echo "Commandes disponibles :"
    echo "neko-script télécharger           - Installer nekoScript"
    echo "neko-script run fichier.neko      - Exécuter un fichier"
    echo "neko-script publish lib.neko      - Publier une librairie"
    echo "neko-script librairie lib.neko    - Importer une librairie"
    ;;
esac
