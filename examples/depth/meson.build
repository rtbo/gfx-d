
executable('gfx_depth', 'source/depth.d',
    build_by_default: true,
    install: get_option('install_examples'),
    include_directories: include_directories('source'),
    dependencies: [ ex_common_dep, genmesh_dep ],
    d_import_dirs: include_directories('views'),
)
