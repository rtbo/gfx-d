
decl_sources = [
    'source/gfx/decl/sdlang/ast.d',
    'source/gfx/decl/sdlang/exception.d',
    'source/gfx/decl/sdlang/lexer.d',
    'source/gfx/decl/sdlang/libInputVisitor.d',
    'source/gfx/decl/sdlang/package.d',
    'source/gfx/decl/sdlang/parser.d',
    'source/gfx/decl/sdlang/symbol.d',
    'source/gfx/decl/sdlang/taggedalgebraic.d',
    'source/gfx/decl/sdlang/token.d',
    'source/gfx/decl/sdlang/util.d',
    'source/gfx/decl/engine.d',
    'source/gfx/decl/store.d',
]

decl_soversion = 0

decl_inc = include_directories('source')

decl_deps = [ graal_dep ]

decl_lib = library('gfxd_decl', decl_sources,
    include_directories: decl_inc,
    dependencies: decl_deps,
    install: true,
    version: meson.project_version(),
    soversion: decl_soversion,
)

decl_dep = declare_dependency(
    include_directories: decl_inc,
    link_with: decl_lib,
    dependencies: decl_deps,
)

if not get_option('disable_tests')
    decl_test = executable('decl_test', decl_sources,
        include_directories: decl_inc,
        dependencies: decl_deps,
        d_unittest: true,
        install: false,
        link_args: ['-main'],
    )

    test('decl', decl_test)
endif

pkgc.generate(decl_lib,
    name: 'gfxd_decl',
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d decl library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
