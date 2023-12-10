# Change Log

All notable changes to this project will be documented in this file.

## [0.0.7] - 2023-12-10

### Added

- New maps to `maplist.sql`
    - Current map count: `819`

## [0.0.6] - 2023-07-16

### Added

- `maplist.sql` - `DROP TABLE IF EXISTS` for easier update
- `maplist.sql`
    - surf_seaside

### Changed

- `maplist.sql`
    - surf_assail `tier 4 -> 5`
    - surf_intra `tier 4 -> 5`
    - surf_undergrowth `tier 2 -> 3`

## [0.0.5] - 2023-07-15

### Fixed

- `Invalid query Handle 0 (error: 4)`

## [0.0.4] - 2023-07-15

### Changed

- Whole codebase rework to use threaded mysql connections

## [0.0.3] - 2023-07-14

### Added

- Ability to select which database to use

## [0.0.2] - 2023-07-14

### Added

- Ability to query any map instead of only current map