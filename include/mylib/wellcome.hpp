/**
 * @file        wellcome.hpp
 * @license     MIT
 * @version     1.0.0
 * @brief       [Header] Wellcome module for greeting developers
 *
 * @description Just for welcoming the developer to the new project
 */

#pragma once

#include <iostream>
#include <nlohmann/json.hpp>
#include <string>
#include <string_view>
#include <version.hpp>

const std::string COLOR_RESET = "\033[0m";
const std::string COLOR_GREEN = "\033[1;32m";
const std::string COLOR_CYAN = "\033[1;34m";
const std::string COLOR_MAGENTA = "\033[1;35m";

void make_greeting(std::string_view name);
