#include <mylib/wellcome.hpp>
#include <string>
#include <string_view>

std::string make_greeting(std::string_view name)
{
    return "Hello, " + std::string{name} + "!";
}
