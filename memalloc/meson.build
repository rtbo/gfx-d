
memalloc_sources = [
    'source/gfx/memalloc/dedicated.d',
    'source/gfx/memalloc/package.d',
    'source/gfx/memalloc/pool.d',
]

memalloc_soversion = 0

memalloc_inc = include_directories('source')

memalloc_deps = [ graal_dep ]

memalloc_lib = library('gfxd_memalloc', memalloc_sources,
    include_directories: memalloc_inc,
    dependencies: memalloc_deps,
    install: true,
    version: meson.project_version(),
    soversion: memalloc_soversion,
)

memalloc_dep = declare_dependency(
    include_directories: memalloc_inc,
    link_with: memalloc_lib,
    dependencies: memalloc_deps,
)

if not get_option('disable_tests')
    memalloc_test = executable('memalloc_test', memalloc_sources,
        include_directories: memalloc_inc,
        dependencies: memalloc_deps,
        d_unittest: true,
        install: false,
        link_args: ['-main'],
    )

    test('memalloc', memalloc_test)
endif

pkgc.generate(memalloc_lib,
    name: 'gfxd_memalloc',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d memalloc library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
