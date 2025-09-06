# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Docs

- Clarify that `style = 'light'` currently aliases the dark palette. A true
  light palette is planned; until then `light` renders identical to `dark`.
- Update Requirements to "Neovim 0.10.0 or higher" and note that the
  `LspInlayHint` highlight group requires Neovim 0.10.0+. Users on older
  versions should upgrade or remove inlay-hint-related configuration.

## [1.0.0] - 2025-09-05

### Added

- Initial release with VSCode Gruvbox Crisp (Highest Contrast, pop) specification
- Pure black (#000000) background for maximum contrast
- Vibrant Dracula-inspired color palette
- Comprehensive Python syntax support:
  - Decorators with purple highlighting
  - self/cls parameters with italic styling
  - Magic methods and dunder methods
  - Type hints and annotations
  - Docstring highlighting
- Full LaTeX highlighting support:
  - LaTeX commands in green
  - Control keywords (\begin, \end) in red
  - Math mode in yellow
  - Environment names in cyan
  - Comments with % in gray italic
- Treesitter support with fallback to legacy vim syntax
- Customizable italics and bold options
- Terminal color configuration
- Override capability for highlight groups
- Soft contrast option switching base editor background to `p.bg1`

### Features

- Maximum contrast with pure black background and pure white foreground
- VSCode theme parity for consistent cross-editor experience
- Language-specific optimizations for Python and LaTeX
- Support for common programming languages (JavaScript, TypeScript, Rust, Go, etc.)

[1.0.0]: https://github.com/VatsalSy/gruvbox_custom_crisp_themes.nvim/releases/tag/v1.0.0
