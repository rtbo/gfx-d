
ex_deferred_src = [
    'source/buffer.d',
    'source/deferred.d',
    'source/pipeline.d',
    'source/scene.d',
]

executable('gfx_deferred', ex_deferred_src,
    build_by_default: true,
    install: get_option('install_examples'),
    include_directories: include_directories('source'),
    dependencies: [ ex_common_dep ],
    d_import_dirs: include_directories('views'),
)
