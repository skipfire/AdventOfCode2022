#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <regex>

using namespace std;

std::vector<std::string> splitString(const std::string& str, const char& sep)
{
    std::vector<std::string> tokens;

    std::stringstream ss(str);
    std::string token;
    while (std::getline(ss, token, sep)) {
        tokens.push_back(token);
    }

    return tokens;
}

int main()
{
    std::cout << "Hello World!\n";
    ifstream f("D:\\GitHub\\AdventOfCode2022\\day-4\\input.txt");
    string str;
    if (f) {
        ostringstream ss;
        ss << f.rdbuf();
        str = ss.str();
    }
    int count1 = 0;
    int count2 = 0;
    std::vector<std::string> lines = splitString(str, '\n');
    for (auto const& line : lines) {
        std::vector<std::string> sides = splitString(line, ',');
        std::vector<std::string> left = splitString(sides[0], '-');
        std::vector<std::string> right = splitString(sides[1], '-');

        int leftMin = stoi(left[0]);
        int leftMax = stoi(left[1]);
        int rightMin = stoi(right[0]);
        int rightMax = stoi(right[1]);

        if (leftMin >= rightMin && leftMax <= rightMax) {
            std::cout << line + " - Left redundant" << std::endl;
            count1++;
        }
        else if (rightMin >= leftMin && rightMax <= leftMax) {
            std::cout << line + " - Right redundant" << std::endl;
            count1++;
        }
        else if (leftMin >= rightMin && leftMin <= rightMax) {
            std::cout << line + " - leftMin" << std::endl;
            count2++;
        }
        else if (leftMax >= rightMin && leftMax <= rightMax) {
            std::cout << line + " - leftMax" << std::endl;
            count2++;
        }
        else if (rightMin >= leftMin && rightMin <= leftMax) {
            std::cout << line + " - rightMin" << std::endl;
            count2++;
        }
        else if (rightMax >= leftMin && rightMax <= leftMax) {
            std::cout << line + " - rightMax" << std::endl;
            count2++;
        }

    }
    std::cout << "Count 1: " + std::to_string(count1) << std::endl;
    std::cout << "Count 2: " + std::to_string(count2 + count1) << std::endl;
}
