
#!/bin/bash

COMMAND=$1
ARG=$2

case $COMMAND in
  "télécharger")
    echo "Téléchargement de nekoScript..."
    mkdir -p nekoScript
    git clone https://github.com/tonRepo/nekoScript.git nekoScript
    ;;
  "run")
    if [ -z "$ARG" ]; then
      echo "Spécifiez un fichier .neko à exécuter."
    else
      ./bin/neko-script "$ARG"
    fi
    ;;
  "publish")
    if [ -z "$ARG" ]; then
      echo "Spécifiez un nom de bibliothèque à publier."
    else
      mkdir -p published_libs
      cp "libs/$ARG" "published_libs/$ARG"
      echo "Librairie $ARG publiée avec succès."
    fi
    ;;
  "librairie")
    if [ -z "$ARG" ]; then
      echo "Spécifiez une bibliothèque à importer."
    else
      echo "Téléchargement de la librairie $ARG..."
      cp "published_libs/$ARG" "libs/$ARG"
    fi
    ;;
  *)
    echo "Commande inconnue. Commandes disponibles :"
    echo "$neko-script télécharger | run fichier.neko | publish nom.neko | librairie nom.neko"
    ;;
esac
