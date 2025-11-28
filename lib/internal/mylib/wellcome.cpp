/**
 * @file        wellcome.cpp
 * @license     MIT
 * @version     1.0.0
 * @brief       Internal library implementation for welcome message
 */

#include <mylib/wellcome.hpp>

void make_greeting(std::string_view name)
{
    nlohmann::json developer;

    developer["project_version"] = VERSION;
    developer["name"] = name;
    developer["env"] = __VERSION__;

    std::cout << COLOR_GREEN << "Welcome " << COLOR_CYAN << developer["name"].get<std::string>()
              << COLOR_GREEN << " to the C++ project v" << COLOR_MAGENTA
              << developer["project_version"].get<std::string>() << COLOR_GREEN << " running on "
              << COLOR_CYAN << developer["env"].get<std::string>() << COLOR_RESET << std::endl;
}
