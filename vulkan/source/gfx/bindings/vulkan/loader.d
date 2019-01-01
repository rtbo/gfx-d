
/// Loader module for vkdgen.
/// Loading bindings is done in 3 steps as follow:
/// ---
/// import gfx.bindings.vulkan.loader;
///
/// // load global commands
/// auto globVk = loadVulkanGlobalCmds();
///
/// // load instance commands
/// VkInstance inst;
/// VkInstanceCreateInfo instCreateInfo = // ...
/// globVk.CreateInstance(&instCreateInfo, null, &inst);
/// auto instVk = new VkInstanceCmds(inst, globVk);
///
/// // load device commands
/// VkPhysicalDevice phDev = // ...
/// VkDevice dev;
/// VkDeviceCreateInfo devCreateInfo = // ...
/// instVk.CreateDevice(phDev, &devCreateInfo, null, &dev);
/// auto vk = new VkDeviceCmds(dev, instVk);
///
/// // vk.CreateBuffer(dev, ...);
/// ---
module gfx.bindings.vulkan.loader;

import gfx.bindings.vulkan.vk : VkGlobalCmds;

import std.exception;

/// A handle to a shared library
alias SharedLib = void*;
/// A handle to a shared library symbol
alias SharedSym = void*;

/// Opens a shared library.
/// Return null in case of failure.
SharedLib openSharedLib(string name);

/// Load a symbol from a shared library.
/// Return null in case of failure.
SharedSym loadSharedSym(SharedLib lib, string name);

/// Close a shared library
void closeSharedLib(SharedLib lib);


/// Generic Dynamic lib symbol loader.
/// Symbols loaded with such loader must be cast to the appropriate function type.
alias SymbolLoader = SharedSym delegate (in string name);


version(Posix)
{
    import std.string : toStringz;
    import core.sys.posix.dlfcn;

    SharedLib openSharedLib(string name)
    {
        return dlopen(toStringz(name), RTLD_LAZY);
    }

    SharedSym loadSharedSym(SharedLib lib, string name)
    {
        return dlsym(lib, toStringz(name));
    }

    void closeSharedLib(SharedLib lib)
    {
        dlclose(lib);
    }
}
version(Windows)
{
    import std.string : toStringz;
    import core.sys.windows.winbase;

    SharedLib openSharedLib(string name)
    {
        return LoadLibraryA(toStringz(name));
    }

    SharedSym loadSharedSym(SharedLib lib, string name)
    {
        return GetProcAddress(lib, toStringz(name));
    }

    void closeSharedLib(SharedLib lib)
    {
        FreeLibrary(lib);
    }
}

/// Load global commands from Vulkan DLL/Shared object.
/// Returns: a VkGlobalCmds object
VkGlobalCmds loadVulkanGlobalCmds()
{
    import gfx.bindings.vulkan.vk : PFN_vkGetInstanceProcAddr;

    version( Windows )
        enum libName = "vulkan-1.dll";
    else version( Posix )
        enum libName = "libvulkan.so.1";
    else
        static assert (false, "Vulkan bindings not supported on this OS");

    auto lib = enforce(openSharedLib(libName), "Cannot open "~libName);

    auto getInstanceProcAddr = enforce(
        cast(PFN_vkGetInstanceProcAddr)loadSharedSym(lib, "vkGetInstanceProcAddr"),
        "Could not load vkGetInstanceProcAddr from "~libName
    );

    return new VkGlobalCmds(getInstanceProcAddr);
}
