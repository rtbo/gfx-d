
window_sources = [
    'source/gfx/window/wayland/package.d',
    'source/gfx/window/wayland/xdg_shell.d',
    'source/gfx/window/win32/context.d',
    'source/gfx/window/win32/keymap.d',
    'source/gfx/window/win32/package.d',
    'source/gfx/window/xcb/context.d',
    'source/gfx/window/xcb/package.d',
    'source/gfx/window/keys.d',
    'source/gfx/window/package.d',
    'source/gfx/window/xkeyboard.d',
]

window_soversion = 0

window_inc = include_directories('source')

window_deps = [ graal_dep, gl3_dep, vulkan_dep ]

if host_machine.system() == 'linux'
    window_deps += [
        wayland_client_dep,
        wayland_cursor_dep,
        xcb_dep,
        xkbcommon_dep,
    ]
endif

window_lib = library('gfxd_window', window_sources,
    include_directories: window_inc,
    dependencies: window_deps,
    install: true,
    version: meson.project_version(),
    soversion: window_soversion,
    d_module_versions: ['WlStatic'],
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
