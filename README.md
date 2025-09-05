# gruvbox_custom_crisp_themes.nvim

A minimal Neovim colorscheme scaffold in Lua. It ships with a crisp, gruvbox‑inspired dark/light palette, sensible defaults, and a small API to tweak italics, bold, transparency, and per‑group overrides.

The internal module name and colorscheme name are `gruvbox_crisp`.

## Install

Use your preferred plugin manager.

### lazy.nvim

```lua
{
  -- replace "your/repo" when publishing
  "your/repo",
  name = "gruvbox_crisp",
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox_crisp").setup({
      style = "dark",       -- "dark" | "light"
      transparent = false,
      italics = {
        comments = true,
        strings = false,
        keywords = false,
        functions = false,
        variables = false,
      },
      bold = { functions = true },
      overrides = {},       -- table of highlight group overrides
    })
    vim.cmd.colorscheme("gruvbox_crisp")
  end,
}
```

### packer.nvim

```lua
use({
  "your/repo",
  config = function()
    require("gruvbox_crisp").setup({ style = "dark" })
    vim.cmd.colorscheme("gruvbox_crisp")
  end,
})
```

## Options

- `style`: "dark" | "light"
- `transparent`: disable background on main windows
- `terminal_colors`: set `terminal_color_0..15` from the palette (default true)
- `italics`: `{ comments, strings, keywords, functions, variables }`
- `bold`: `{ functions }`
- `overrides`: table of `{ ["GroupName"] = { fg=..., bg=..., ... } }`

## Development

- Entry point: `colors/gruvbox_crisp.lua`
- Core: `lua/gruvbox_crisp/`
- Palette: `lua/gruvbox_crisp/palette.lua`
- Highlight groups: `lua/gruvbox_crisp/groups.lua`

To rename the scheme later, replace `gruvbox_crisp` in file paths and strings and rename `colors/gruvbox_crisp.lua` accordingly.

## License

MIT © 2025 Vatsal Sanjay
