
core_sources = [
    'source/gfx/core/log.d',
    'source/gfx/core/package.d',
    'source/gfx/core/rc.d',
    'source/gfx/core/typecons.d',
    'source/gfx/core/util.d',
    'source/gfx/priv/datetimeformat.d',
]

core_soversion = 0

core_inc = include_directories('source')

core_lib = library('gfxd_core', core_sources,
    include_directories: core_inc,
    install: true,
    version: meson.project_version(),
    soversion: core_soversion,
)

core_dep = declare_dependency(
    include_directories: core_inc,
    link_with: core_lib,
)

core_test = executable('core_test', core_sources,
    include_directories: core_inc,
    d_unittest: true,
    install: false,
    d_module_versions: ['MissingTestMain'],
)

test('core', core_test)

pkgc.generate(core_lib,
    name: 'gfxd_core',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d core library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
