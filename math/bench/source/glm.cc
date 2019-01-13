#define GLM_FORCE_RADIANS 1
#include <glm/vec3.hpp> // glm::vec3
#include <glm/vec4.hpp> // glm::vec4
#include <glm/mat4x4.hpp> // glm::mat4
#include <glm/gtc/matrix_transform.hpp> // glm::translate, glm::rotate, glm::scale, glm::perspective
#include <iostream>

void print(const glm::mat4 & m) {
    std::cout << "[\n";
    for (int r=0; r<4; ++r) {
        std::cout << "    [ ";
        for (int c=0; c<4; ++c) {
            std::cout << m[c][r] << ", ";
        }
        std::cout << "],\n";
    }
    std::cout << "]\n";
}

extern "C" int glm_matmul(int iter)
{
    const auto axis = glm::vec3(1, 2, 3);
    const auto sc = glm::vec3(0.5, 2, 0.5);
    const auto tr = glm::vec3(4, 5, 6);

    const auto r = glm::rotate(glm::mat4(1.0), 0.01f, axis);
    const auto even = glm::translate(glm::scale(r, sc), tr);
    const auto odd = glm::translate(glm::scale(r, 1.0f/sc), -tr);

    auto m = glm::mat4(1.0);

    for (auto i=0; i<iter; ++i) {
        if (i % 2) {
            m = odd * m;
        }
        else {
            m = even * m;
        }
    }

    // std::cout << "glm mul" << std::endl;
    // print(m);
    if (m == glm::mat4(1.0)) {
        std::cout << "only to make sure computation is not optimized away" << std::endl;
    }

    return iter;
}

extern "C" int glm_matinv(int iter)
{
    const auto axis = glm::vec3(1, 2, 3);
    const auto sc = glm::vec3(0.5, 2, 0.5);
    const auto tr = glm::vec3(4, 5, 6);

    const auto r = glm::rotate(glm::mat4(1.0), 0.01f, axis);
    auto m = glm::translate(glm::scale(r, sc), tr);

    for (auto i=0; i<iter; ++i) {
        m = glm::inverse(m);
    }

    // std::cout << "glm inverse" << std::endl;
    // print(m);
    if (m == glm::mat4(1.0)) {
        std::cout << "only to make sure computation is not optimized away" << std::endl;
    }

    return iter;
}
