
window_sources = [
    'source/gfx/window/keys.d',
    'source/gfx/window/package.d',
    'source/gfx/window/xkeyboard.d',
]
window_deps = [ graal_dep, vulkan_dep ]

window_vers = []

if get_option('enable_gl3')
    window_deps += [ gl3_dep ]
    window_vers += [ 'GfxGl3' ]
endif

if host_machine.system() == 'linux'
    window_vers += ['VkXcb']
    window_sources += [
        'source/gfx/window/xcb/package.d',
    ]
    window_deps += [
        xcb_dep,
        xlib_dep,
        xkbcommon_dep,
    ]
    if get_option('enable_gl3')
        window_sources += [
            'source/gfx/window/xcb/context.d',
        ]
    endif
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
elif host_machine.system() == 'windows'
    window_deps += [
        declare_dependency(
            link_args: ['user32.lib', 'gdi32.lib']
        )
    ]
    window_sources += [
        'source/gfx/window/win32/keymap.d',
        'source/gfx/window/win32/package.d',
    ]
    if get_option('enable_gl3')
        window_sources += [
            'source/gfx/window/win32/context.d',
        ]
    endif
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

# if not get_option('disable_tests')
#     window_test = executable('window_test', window_sources,
#         include_directories: window_inc,
#         dependencies: window_deps,
#         d_unittest: true,
#         install: false,
#         d_module_versions: ['WlStatic'],
#         link_args: ['-main'],
#     )
#
#     test('window', window_test)
# endif

pkgc.generate(window_lib,
    name: 'gfxd_window',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d window library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
