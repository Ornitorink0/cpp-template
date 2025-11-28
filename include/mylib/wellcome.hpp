#pragma once

#include <string>
#include <string_view>

const std::string COLOR_RESET = "\033[0m";
const std::string COLOR_GREEN = "\033[1;32m";
const std::string COLOR_CYAN = "\033[1;34m";
const std::string COLOR_MAGENTA = "\033[1;35m";

std::string make_greeting(std::string_view name);
