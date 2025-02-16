# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2023-08-01

### Added

- Semantic versioning support
- Lifecycle hooks documentation
- Enhanced test coverage

### Changed

- Updated minimum Flutter SDK to 3.0.0
- Improved controller disposal logic

## [0.1.0] - 2025-02-16

### Added

- Initial release of Reign state management
- Core Controller class with lifecycle management
- ControllerProvider and ControllerConsumer widgets
- Basic test suite

## 0.3.0 - 2023-08-20

### Breaking Changes

- Renamed `MultiProvider` to `ReignMultiProvider` to avoid naming conflicts
- Removed module system (`ReignModule` and related classes)
- Lifecycle methods renamed:
  - `onInit()` → `setup()`
  - `onDispose()` → `cleanup()`

### Added

- Complete example app with:
  - 4 demonstration screens
  - 5 example controllers
  - Full navigation implementation
- New annotation-based API for:
  - `@ReignController`
  - `@Injectable`
  - `@Component`

### Fixed

- Circular dependency handling in controller initialization
- Missing type definitions in example app
- Incorrect lifecycle method overrides
- Documentation inconsistencies

### Removed

- Deprecated `dependOn()` method (use `find()` instead)
- Unused module provider system
- Redundant decorator implementations
