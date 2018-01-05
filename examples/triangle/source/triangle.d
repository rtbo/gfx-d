module triangle;

import erupted;

import gfx.backend.vulkan;
import gfx.core.rc;


int main() {
    DerelictErupted.load();
    auto instance = createVulkanInstance().rc;
    return 0;
}
