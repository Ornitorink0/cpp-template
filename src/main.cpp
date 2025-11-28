#include <iostream>
#include <mylib/wellcome.hpp>
#include <nlohmann/json.hpp>
#include <version.hpp>

using json = nlohmann::json;

int main()
{
    json developer;
    developer["name"] = "John";
    developer["power"] = 999;

    std::cout << COLOR_GREEN << "project v" << VERSION << COLOR_RESET << std::endl;
    std::cout << COLOR_CYAN << make_greeting("Developer") << COLOR_RESET << std::endl;
    std::cout << COLOR_MAGENTA << "Running: " << __VERSION__ << COLOR_RESET << std::endl << std::endl;

    // test
    std::cout << "Program example: " << std::endl;
    std::cout << developer.dump(2) << std::endl;

    return 0;
}