# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2020-11-15

### Changed

 - Fix a few unittest
 - Fix subpackage references in DUB. This could impact code depending on gfx-d


## [0.2.0] - 2020-11-15

### Added

 - Travis CI
 - ImageAcquisition construct in the swapchain
 - wayland backend in gfx.window
 - secondary command buffers
 - Deferred lighting example
 - This changelog

### Changed

 - NDC (normalized device coordinates) is used instead of ProjConfig
 - vkdgen and gldgen are externalized
 - Changed the descriptors API (as view methods)
 - Various fixes in the examples
 - Math code is @safe pure @nogc nothrow
 - fix usage of deprecated API in the sdlang module


## [0.1.2] - 2018-12-25

### Changed

 - fix build on Windows


## [0.1.1] - 2018-12-24

### Added

 - Using spirv_cross-d from dub
 - AtomicRefCounted class that avoid compiled code duplication
 - Y inversion is done by the projection matrices
 - Improve logging module

### Changed

 - AtomicRefCounted is renamed to IAtomicRefCounted


## [0.1.0] - 2018-12-16

 - Initial release
