# gruvbox_custom_crisp_themes.nvim

A high-contrast Neovim colorscheme based on the VSCode "Gruvbox Crisp Anysphere (Highest Contrast, pop)" specification. Features pure black backgrounds, vibrant Dracula-inspired colors, and extensive language-specific support for Python, LaTeX, and more.

## ✨ Features

- **Maximum Contrast**: Pure black (#000000) background with pure white (#ffffff) foreground
- **VSCode Parity**: Exact color matching with VSCode Gruvbox Crisp theme
- **Language Support**: 
  - Python: Decorators, self/cls, magic methods, type hints
  - LaTeX: Commands, environments, math mode, citations
  - Full Treesitter support with fallback to legacy syntax
- **Customizable**: Configure italics, bold, transparency per element

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (recommended)

```lua
{
  "VatsalSy/gruvbox_custom_crisp_themes.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox_crisp").setup({
      style = "dark",
      transparent = false,
      italics = {
        comments = true,
        strings = false,
        keywords = false,
        functions = false,
        variables = false,
      },
      bold = { functions = true },
    })
    vim.cmd.colorscheme("gruvbox_crisp")
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "VatsalSy/gruvbox_custom_crisp_themes.nvim",
  config = function()
    require("gruvbox_crisp").setup()
    vim.cmd.colorscheme("gruvbox_crisp")
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'VatsalSy/gruvbox_custom_crisp_themes.nvim'
```

Then in your config:
```vim
colorscheme gruvbox_crisp
```

## 🎨 Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Background | Pure Black | `#000000` |
| Foreground | Pure White | `#ffffff` |
| Comments | Blue-Gray | `#6272a4` |
| Strings | Bright Green | `#50fa7b` |
| Keywords | Pale Yellow | `#f1fa8c` |
| Functions | Hot Pink | `#ff79c6` |
| Numbers | Bright Purple | `#bd93f9` |
| Types | Bright Cyan | `#8be9fd` |
| Operators | Orange | `#ffb86c` |

## 🔧 Configuration

```lua
require("gruvbox_crisp").setup({
  style = "dark",       -- Currently only dark is implemented
  transparent = false,  -- Transparent background
  terminal_colors = true, -- Set terminal colors
  italics = {
    comments = true,
    strings = false,
    keywords = false,
    functions = false,
    variables = false,
  },
  bold = {
    functions = true,
  },
  overrides = {}, -- Override specific highlight groups
})
```

### Override Examples

```lua
require("gruvbox_crisp").setup({
  overrides = {
    -- Make comments bold and italic
    Comment = { fg = "#6272a4", bold = true, italic = true },
    -- Change function color
    Function = { fg = "#50fa7b" },
  }
})
```

## 🐍 Python Support

The theme includes comprehensive Python highlighting:

- **Decorators** (`@property`, `@staticmethod`): Purple `#9b4fa0`
- **Self/cls**: Mauve italic `#d3869b`
- **Built-in functions** (`print`, `len`): Orange `#fe8019`
- **Magic methods** (`__init__`, `__str__`): Type color `#8ec07c`
- **Docstrings**: Comment style with italics
- **Type hints**: Cyan `#8be9fd`
- **Keywords** (`class`, `def`, `async`): Red `#fb4934`

## 📐 LaTeX Support

Extensive LaTeX highlighting with proper coloring:

- **Commands** (`\documentclass`, `\usepackage`): Green `#b8bb26`
- **Control keywords** (`\begin`, `\end`): Red `#fb4934`
- **Math mode**: Yellow `#fabd2f`
- **Environment names**: Cyan `#8be9fd`
- **Comments** (starting with `%`): Gray italic `#7c6f64`

## 📝 Language Examples

See the `examples/` directory for syntax highlighting demonstrations in:
- Python (`demo.py`)
- LaTeX (`demo.tex`)
- JavaScript/TypeScript (`demo.js`, `demo.ts`)
- Rust (`demo.rs`)
- Go (`demo.go`)
- And more...

## 🚀 Requirements

- Neovim 0.8.0 or higher
- `termguicolors` enabled
- Optional: Treesitter for enhanced syntax highlighting

## 📄 License

MIT © 2025 Vatsal Sanjay

## 🙏 Acknowledgments

- Based on the VSCode Gruvbox Crisp theme specification
- Color palette inspired by Dracula theme
- Original gruvbox theme by morhetz