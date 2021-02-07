
window_sources = [
    'source/gfx/window/keys.d',
    'source/gfx/window/package.d',
    'source/gfx/window/xkeyboard.d',
]
window_deps = [ graal_dep, gl3_dep, vulkan_dep ]

window_vers = []

if host_machine.system() == 'linux'
    window_vers = ['VkXcb']
    window_sources += [
        'source/gfx/window/xcb/context.d',
        'source/gfx/window/xcb/package.d',
    ]
    window_deps += [
        xcb_dep,
        xkbcommon_dep,
    ]
    if not get_option('disable_wayland')
        window_vers += ['WlStatic', 'VkWayland']
        window_sources += [
            'source/gfx/window/wayland/package.d',
            'source/gfx/window/wayland/xdg_shell.d',
        ]
        window_deps += [
            wayland_client_dep,
            wayland_cursor_dep,
        ]
    endif
endif

if host_machine.system() == 'windows'
    window_sources += [
        'source/gfx/window/win32/context.d',
        'source/gfx/window/win32/keymap.d',
        'source/gfx/window/win32/package.d',
    ]
endif

window_soversion = 0

window_inc = include_directories('source')
if host_machine.system() == 'linux'
endif

window_lib = library('gfxd_window', window_sources,
    include_directories: window_inc,
    dependencies: window_deps,
    install: true,
    version: meson.project_version(),
    soversion: window_soversion,
    d_module_versions: window_vers,
)

window_dep = declare_dependency(
    include_directories: window_inc,
    link_with: window_lib,
    dependencies: window_deps,
)

# window_test = executable('window_test', window_sources,
#     include_directories: window_inc,
#     dependencies: window_deps,
#     d_unittest: true,
#     install: false,
#     d_module_versions: ['WlStatic', 'MissingTestMain'],
# )
#
# test('window', window_test)

pkgc.generate(window_lib,
    name: 'gfxd_window',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d window library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
