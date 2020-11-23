
graal_sources = [
    'source/gfx/graal/buffer.d',
    'source/gfx/graal/cmd.d',
    'source/gfx/graal/device.d',
    'source/gfx/graal/error.d',
    'source/gfx/graal/format.d',
    'source/gfx/graal/image.d',
    'source/gfx/graal/memory.d',
    'source/gfx/graal/package.d',
    'source/gfx/graal/pipeline.d',
    'source/gfx/graal/presentation.d',
    'source/gfx/graal/queue.d',
    'source/gfx/graal/renderpass.d',
    'source/gfx/graal/sync.d',
    'source/gfx/graal/types.d',
    'source/gfx/package.d',
]

graal_soversion = 0

graal_inc = include_directories('source')

graal_deps = [ core_dep, math_dep ]

graal_lib = library('gfxd_graal', graal_sources,
    include_directories: graal_inc,
    dependencies: graal_deps,
    install: true,
    version: meson.project_version(),
    soversion: graal_soversion,
)

graal_dep = declare_dependency(
    include_directories: graal_inc,
    link_with: graal_lib,
    dependencies: graal_deps,
)

graal_test = executable('graal_test', graal_sources,
    include_directories: graal_inc,
    dependencies: graal_deps,
    d_unittest: true,
    install: false,
    d_module_versions: ['MissingTestMain'],
)

test('graal', graal_test)

pkgc.generate(graal_lib,
    name: 'gfxd_graal',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d graal library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
