
# Guide d'Installation de NekoScript

## Prérequis
- Un compte Replit
- Un terminal Linux/Unix

## Installation

1. **Cloner le projet**
   - Fork ce projet sur Replit
   - Ouvrez le terminal dans Replit

2. **Rendre le script exécutable**
   ```bash
   chmod +x neko-script.sh
   ```

3. **Installer NekoScript**
   ```bash
   ./neko-script.sh télécharger
   ```
   Cette commande va :
   - Installer les dépendances nécessaires (Node.js, G++)
   - Créer les dossiers requis
   - Compiler le code source
   - Configurer l'environnement

4. **Vérifier l'installation**
   ```bash
   source ~/.bashrc
   neko-script
   ```
   Vous devriez voir la liste des commandes disponibles.

## Utilisation

### Exécuter un script
```bash
neko-script run mon_script.neko
```

### Publier un package
```bash
neko-script publish mon_package.neko
```

### Importer une librairie
```bash
neko-script librairie nom_librairie.neko
```

## Structure d'un package
```neko
package:
  name: "mon-package"
  version: "1.0.0"
  description: "Description"

fonction maFonction:
  # Code NekoScript
```

## Support
Pour toute question ou problème, ouvrez une issue sur ce projet Replit.
