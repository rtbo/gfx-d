
genmesh_sources = [
    'source/gfx/genmesh/algorithm.d',
    'source/gfx/genmesh/cube.d',
    'source/gfx/genmesh/poly.d',
]

genmesh_soversion = 0

genmesh_inc = include_directories('source')

genmesh_lib = library('gfxd_genmesh', genmesh_sources,
    include_directories: genmesh_inc,
    install: true,
    version: meson.project_version(),
    soversion: genmesh_soversion,
)

genmesh_dep = declare_dependency(
    include_directories: genmesh_inc,
    link_with: genmesh_lib,
)

genmesh_test = executable('genmesh_test', genmesh_sources,
    include_directories: genmesh_inc,
    d_unittest: true,
    install: false,
    d_module_versions: ['MissingTestMain'],
)

test('genmesh', genmesh_test)

pkgc.generate(genmesh_lib,
    name: 'gfxd_genmesh',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d genmesh library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
