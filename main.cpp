
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
        std::cerr << "Utilisation: neko-script <fichier.neko>" << std::endl;
        return 1;
    }
    run_script(argv[1]);
    return 0;
}
