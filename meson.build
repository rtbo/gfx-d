project('gfx-d', ['d', 'cpp'],
    version: '0.2.2',
    default_options: ['cpp_std=c++14']
)

spirv_cross_proj = subproject('spirv_cross-d',
    default_options: ['cpp_std=c++14'],
)

spirv_cross_dep = spirv_cross_proj.get_variable('spirv_cross_dep')

if host_machine.system() == 'linux'

    if not get_option('disable_wayland')
        wayland_client_dep = dependency('wayland:client',
            version: '~>0.2.0',
            method: 'dub',
        )
        wayland_cursor_dep = dependency('wayland:cursor',
            version: '~>0.2.0',
            method: 'dub',
        )
    endif

    xcb_dep = dependency('xcb-d',
        version: '2.1.1+1.11.1',
        method: 'dub',
    )
    xlib_dep = dependency('xlib-d',
        version: '~>0.2.0',
        method: 'dub',
    )
    xkbcommon_dep = dependency('xkbcommon-d',
        version: '~>0.5.1',
        method: 'dub',
    )
endif

pkgc = import('pkgconfig')

subdir('core')
subdir('math')
subdir('genmesh')
subdir('graal')
subdir('decl')
subdir('memalloc')
subdir('vulkan')

if get_option('enable_gl3')
    subdir('gl3')
endif

if not get_option('disable_window')
    subdir('window')
endif

if get_option('enable_examples')
    message('Enabling examples')
    subdir('examples')
else
    message('Disabling examples')
endif
