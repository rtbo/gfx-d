project('gfx-d', 'd',
    version: '0.2.2',
)

spirv_cross_proj = subproject('spirv_cross-d')

spirv_cross_dep = spirv_cross_proj.get_variable('spirv_cross_dep')

if host_machine.system() == 'linux'
    wayland_client_dep = dependency('wayland:client',
        version: '~>0.2.0',
        method: 'dub',
    )
    wayland_cursor_dep = dependency('wayland:cursor',
        version: '~>0.2.0',
        method: 'dub',
    )
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
subdir('gl3')
subdir('window')

subdir('examples')
