
vulkan_sources = [
    'source/gfx/bindings/vulkan/loader.d',
    'source/gfx/bindings/vulkan/package.d',
    'source/gfx/bindings/vulkan/vk.d',
    'source/gfx/vulkan/buffer.d',
    'source/gfx/vulkan/cmd.d',
    'source/gfx/vulkan/conv.d',
    'source/gfx/vulkan/device.d',
    'source/gfx/vulkan/error.d',
    'source/gfx/vulkan/image.d',
    'source/gfx/vulkan/memory.d',
    'source/gfx/vulkan/package.d',
    'source/gfx/vulkan/pipeline.d',
    'source/gfx/vulkan/queue.d',
    'source/gfx/vulkan/renderpass.d',
    'source/gfx/vulkan/sync.d',
    'source/gfx/vulkan/wsi.d',
]

vulkan_soversion = 0

vulkan_inc = include_directories('source')

vulkan_deps = [ graal_dep ]
vulkan_vers = []

if host_machine.system() == 'linux'
    vulkan_vers += [ 'VkXcb' ]
    vulkan_deps += [ xcb_dep ]
    if not get_option('disable_wayland')
        vulkan_vers += [ 'VkWayland' ]
        vulkan_deps += [ wayland_client_dep ]
    endif
endif

vulkan_lib = library('gfxd_vulkan', vulkan_sources,
    include_directories: vulkan_inc,
    dependencies: vulkan_deps,
    install: true,
    d_module_versions: vulkan_vers,
    version: meson.project_version(),
    soversion: vulkan_soversion,
)

vulkan_dep = declare_dependency(
    include_directories: vulkan_inc,
    link_with: vulkan_lib,
    dependencies: vulkan_deps,
)

if not get_option('disable_tests')
    vulkan_test = executable('vulkan_test', vulkan_sources,
        include_directories: vulkan_inc,
        dependencies: vulkan_deps,
        d_unittest: true,
        install: false,
        d_module_versions: vulkan_vers,
        link_args: ['-main'],
    )

    test('vulkan', vulkan_test)
endif

pkgc.generate(vulkan_lib,
    name: 'gfxd_vulkan',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d vulkan library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
