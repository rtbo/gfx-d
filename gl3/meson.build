
gl3_sources = [
    'source/gfx/bindings/opengl/gl.d',
    'source/gfx/bindings/opengl/glx.d',
    'source/gfx/bindings/opengl/khrplatform.d',
    'source/gfx/bindings/opengl/loader.d',
    'source/gfx/bindings/opengl/util.d',
    'source/gfx/bindings/opengl/wgl.d',
    'source/gfx/gl3/context.d',
    'source/gfx/gl3/conv.d',
    'source/gfx/gl3/device.d',
    'source/gfx/gl3/error.d',
    'source/gfx/gl3/package.d',
    'source/gfx/gl3/pipeline.d',
    'source/gfx/gl3/queue.d',
    'source/gfx/gl3/resource.d',
    'source/gfx/gl3/swapchain.d',
]

gl3_soversion = 0

gl3_inc = include_directories('source')

gl3_deps = [ graal_dep, spirv_cross_dep ]

if host_machine.system() == 'linux'
    gl3_deps += [ xcb_dep, xlib_dep ]
endif

gl3_lib = library('gfxd_gl3', gl3_sources,
    include_directories: gl3_inc,
    dependencies: gl3_deps,
    install: true,
    version: meson.project_version(),
    soversion: gl3_soversion,
)

gl3_dep = declare_dependency(
    include_directories: gl3_inc,
    link_with: gl3_lib,
    dependencies: gl3_deps,
)

gl3_test = executable('gl3_test', gl3_sources,
    include_directories: gl3_inc,
    dependencies: gl3_deps,
    d_unittest: true,
    install: false,
    d_module_versions: ['MissingTestMain'],
)

test('gl3', gl3_test)

pkgc.generate(gl3_lib,
    name: 'gfxd_gl3',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d gl3 library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
