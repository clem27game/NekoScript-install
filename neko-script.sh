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

# Créer les fichiers requis pour NekoScript
cat << 'EOF' > "$NEKO_LIB_DIR/bin/main.cpp"
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <map>
#include "package_manager.cpp"

std::map<std::string, int> variables;

void interpret_line(const std::string& line) {
    if (is_custom_function(line)) {
        execute_custom_function(line);
        return;
    }
    if (line.find("neko =") == 0) {
        auto start = line.find('"') + 1;
        auto end = line.rfind('"');
        std::string msg = line.substr(start, end - start);
        std::cout << msg << std::endl;
    } else if (line.find("nekimg =") == 0) {
        auto start = line.find('"') + 1;
        auto end = line.rfind('"');
        std::string url = line.substr(start, end - start);
        std::cout << "[Image] " << url << std::endl;
    } else if (line.find('=') != std::string::npos) {
        std::string var = line.substr(0, line.find('='));
        std::string expr = line.substr(line.find('=') + 1);
        var.erase(remove_if(var.begin(), var.end(), isspace), var.end());
        expr.erase(0, expr.find_first_not_of(' '));

        std::istringstream iss(expr);
        int a, b;
        std::string op;
        iss >> a >> op >> b;

        int result = 0;
        if (line.find("compteneko") == 0) {
            std::string expr = line.substr(11);
            std::istringstream iss(expr);
            int a, b;
            std::string op;
            iss >> a >> op >> b;
            
            if (op == "plus") result = a + b;
            else if (op == "moins") result = a - b;
            else if (op == "diviser") result = a / b;
            else if (op == "multiplier") result = a * b;
            
            std::cout << "Résultat: " << result << std::endl;
        }

        variables[var] = result;
        std::cout << result << std::endl;
    }
}

void run_script(const std::string& path) {
    load_packages();
    std::ifstream file(path);
    std::string line;
    while (std::getline(file, line)) {
        interpret_line(line);
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "Usage: neko-script <commande>" << std::endl;
        std::cout << "Commandes:" << std::endl;
        std::cout << "  télécharger - Installer NekoScript" << std::endl;
        std::cout << "  run         - Exécuter un fichier .neko" << std::endl;
        std::cout << "  publish     - Publier un package" << std::endl;
        std::cout << "  librairie   - Importer un package" << std::endl;
        return 1;
    }
    run_script(argv[1]);
    return 0;
}
EOF

cat << 'EOF' > "$NEKO_LIB_DIR/bin/package_manager.cpp"
#include <iostream>
#include <filesystem>
#include <fstream>
#include <map>

namespace fs = std::filesystem;
std::map<std::string, std::string> custom_functions;

struct Package {
    std::string name;
    std::string version;
    std::string description;
    std::map<std::string, std::string> functions;
};

std::map<std::string, Package> installed_packages;

void load_packages(const std::string& directory = "libs") {
    if (!fs::exists(directory)) return;
    for (const auto& entry : fs::directory_iterator(directory)) {
        std::ifstream file(entry.path());
        std::string line;
        while (std::getline(file, line)) {
            if (line.find("fonction ") == 0) {
                std::string name = line.substr(9, line.find(':') - 9);
                std::string code = line.substr(line.find(':') + 1);
                custom_functions[name] = code;
            }
        }
    }
}

bool is_custom_function(const std::string& line) {
    for (const auto& [name, _] : custom_functions) {
        if (line.find(name + "()") != std::string::npos) return true;
    }
    return false;
}

#include <cstdlib>

void install_discord_deps() {
    std::system("npm install discord.js");
}

void execute_custom_function(const std::string& line) {
    for (const auto& [name, code] : custom_functions) {
        if (line.find(name + "()") != std::string::npos) {
            std::cout << "[Exécution de la fonction personnalisée] " << name << std::endl;
            if (code.find("javascript:") == 0) {
                // Code JavaScript
                std::string js_code = code.substr(11);
                std::string temp_file = "/tmp/temp.js";
                std::ofstream js_file(temp_file);
                js_file << js_code;
                js_file.close();
                std::system(("node " + temp_file).c_str());
                std::remove(temp_file.c_str());
            } else {
                // Code nekoScript standard
                std::cout << code << std::endl;
            }
        }
    }
}
EOF

if [ "$1" = "télécharger" ]; then
    echo "Installation de NekoScript..."

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