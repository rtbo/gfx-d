
math_sources = [
    'source/gfx/math/approx.d',
    'source/gfx/math/inverse.d',
    'source/gfx/math/mat.d',
    'source/gfx/math/package.d',
    'source/gfx/math/proj.d',
    'source/gfx/math/transform.d',
    'source/gfx/math/util.d',
    'source/gfx/math/vec.d',
]

math_soversion = 0

math_inc = include_directories('source')

math_lib = library('gfxd_math', math_sources,
    include_directories: math_inc,
    install: true,
    version: meson.project_version(),
    soversion: math_soversion,
)

math_dep = declare_dependency(
    include_directories: math_inc,
    link_with: math_lib,
)

math_test = executable('math_test', math_sources,
    include_directories: math_inc,
    d_unittest: true,
    install: false,
)

test('math', math_test)

pkgc.generate(
    name: 'gfxd_math',
    libraries: math_lib,
    subdirs: 'd/gfxd',
    version: meson.project_version(),
    description: 'Gfx-d Math library',
)

install_subdir('source/gfx',
    install_dir: 'include/d/gfxd',
)
