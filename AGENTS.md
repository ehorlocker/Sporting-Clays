# Agent Guidelines for Sporting Clays

## Project
Godot 4.6 3D game using Jolt Physics engine. Code organized in: Common/, Entities/, Levels/, Test/, UI/, Utilities/.

## Build/Test/Lint
- **Lint**: `gdlint <directory>/` (e.g., `gdlint Test/`)
- **Format**: `gdformat <directory>/` (e.g., `gdformat Test/`)
- **Format check**: `gdformat --check <directory>/`
- **Run all tests**: Use Godot editor with GUT plugin (test dir: `res://Test/`)
- **Run single test**: Open Godot editor, select specific test file in GUT panel

## Code Style
- **Language**: GDScript (Godot 4.6+)
- **Formatting**: Use `gdformat` for automatic formatting (enforced via pre-commit hooks)
- **Linting**: Follow `gdlint` rules (enforced via pre-commit hooks and CI)
- **Encoding**: UTF-8 (per .editorconfig)
- **Exclusions**: Never modify `addons/` directory (third-party GUT testing framework)
- **Naming**: Follow GDScript conventions (snake_case for variables/functions, PascalCase for classes)
- **Types**: Use static typing where possible (GDScript 2.0 style)
- **File organization**: Place files in appropriate directories (Common/, Entities/, Levels/, UI/, Utilities/)

## Pre-commit Hooks
The project uses `gdlint` and `gdformat` pre-commit hooks. Run `pre-commit install` to enable.
