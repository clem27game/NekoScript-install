
#include <iostream>
#include <filesystem>
#include <fstream>
#include <map>

namespace fs = std::filesystem;
std::map<std::string, std::string> custom_functions;

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
