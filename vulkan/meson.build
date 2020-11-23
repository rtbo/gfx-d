
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

if host_machine.system() == 'linux'
    vulkan_deps += [ wayland_client_dep, xcb_dep ]
endif

vulkan_lib = library('gfxd_vulkan', vulkan_sources,
    include_directories: vulkan_inc,
    dependencies: vulkan_deps,
    install: true,
    version: meson.project_version(),
    soversion: vulkan_soversion,
)

vulkan_dep = declare_dependency(
    include_directories: vulkan_inc,
    link_with: vulkan_lib,
    dependencies: vulkan_deps,
)

vulkan_test = executable('vulkan_test', vulkan_sources,
    include_directories: vulkan_inc,
    dependencies: vulkan_deps,
    d_unittest: true,
    install: false,
    d_module_versions: ['MissingTestMain'],
)

test('vulkan', vulkan_test)

pkgc.generate(vulkan_lib,
    name: 'gfxd_vulkan',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d vulkan library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
