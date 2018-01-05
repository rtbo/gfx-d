module gfx.backend.vulkan;

import erupted;

import gfx.core.rc;
import gfx.hal;
import gfx.hal.device;


class VulkanInstance : Instance
{
    mixin(atomicRcCode);

    this(VkInstance vkInst) {
        _vkInst = vkInst;
    }
    override void dispose() {
        vkDestroyInstance(_vkInst, null);
    }
    PhysicalDevice[] devices() {
        return null;
    }
    private VkInstance _vkInst;
}

VulkanInstance createVulkanInstance() {
    VkInstance vkInst;

    VkApplicationInfo ai;
    ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    VkInstanceCreateInfo ici;

    ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    ici.pApplicationInfo = &ai;

    vkCreateInstance(&ici, null, &vkInst);
    loadInstanceLevelFunctions(vkInst);
    return new VulkanInstance(vkInst);
}