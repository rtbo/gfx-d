
ex_common_inc = include_directories('common')
ex_common_deps = [ graal_dep, math_dep, window_dep ]

ex_common_lib = static_library('ex_common', 'common/example.d',
    build_by_default: false,
    install: false,
    include_directories: ex_common_inc,
    dependencies: ex_common_deps,
)

ex_common_dep = declare_dependency(
    include_directories: ex_common_inc,
    dependencies: ex_common_deps,
    link_with: ex_common_lib,
)

subdir('declapi')
subdir('deferred')
subdir('depth')
