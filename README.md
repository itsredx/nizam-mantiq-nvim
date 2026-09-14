# nvim-mantiq

<p align="center">
  <img src="assets/mantiq/Mantiq_Dark.png" alt="Mantiq Logo" width="300" />
  <img src="assets/nizam/Nizam_Dark.png" alt="Nizam Logo" width="300" />
</p>

Tree-sitter based syntax highlighting, filetype detection, devicons, and asset utilities for **Mantiq** (`.mq`) and **Nizam** (`.nz`) in Neovim.

Both languages use the same parser — Mantiq is a strict superset of Nizam.

## Features

- **Tree-sitter Syntax Highlighting** (keywords, types, functions, literals, operators, decorators)
- **Auto-indentation** for Python-style block structure
- **File Type Detection** for `.mq` (Mantiq) and `.nz` (Nizam)
- **Devicon Integration** (`nvim-web-devicons` & `mini.icons`) for file explorers (NvimTree, Neo-tree, Telescope, Oil, Lualine)
- **Logo Preview & Assets API** (`:MantiqLogo` command & `require("mantiq.assets").get_path(lang, variant)`)

## Installation

### lazy.nvim

```lua
{
    "your-username/nvim-mantiq",
    dependencies = { 
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons", -- optional for icons
    },
    config = function()
        require("mantiq").setup({
            -- Optional: custom path to the tree-sitter-mantiq source
            -- parser_path = "/path/to/tree-sitter-mantiq"
        })
    end,
}
```

### Commands & Lua API

- `:MantiqLogo` — Displays the ASCII art logo and PNG asset paths in a floating buffer.
- `require("mantiq.assets").get_path("mantiq", "dark")` — Returns absolute path to `assets/mantiq/Mantiq_Dark.png`.
- `require("mantiq.assets").get_path("nizam", "dark")` — Returns absolute path to `assets/nizam/Nizam_Dark.png`.
- `require("mantiq.assets").get_path("mantiq", "icon")` — Returns absolute path to `assets/mantiq/icon.png`.

## Highlight Groups

| Language Element | Highlight Group |
|-----------------|----------------|
| `fn`, `class`, `struct`, `enum`, etc. | `@keyword` |
| `if`, `for`, `while`, `match`, `try` | `@keyword.conditional` |
| `return`, `break`, `continue` | `@keyword.return` |
| `async`, `virtual`, `static`, `mut` | `@keyword.modifier` |
| `spawn`, `await` | `@keyword.coroutine` |
| `ref`, `deref`, `life` | `@keyword.modifier` |
| Function names | `@function` |
| Function calls | `@function.call` |
| Type names | `@type.definition` |
| Type annotations | `@type` |
| Variables | `@variable` |
| Parameters | `@variable.parameter` |
| `self`, `super` | `@variable.builtin` |
| Numbers, colors | `@number` |
| Strings | `@string` |
| `True`, `False` | `@boolean` |
| `None` | `@constant.builtin` |
| Decorators (`@override`) | `@attribute` |
| Macro invocations (`log!()`) | `@function.macro` |
| Comments (`//`, `/* */`) | `@comment` |
| Operators | `@operator` |
| Import paths | `@module` |

## File Structure

```
nvim-mantiq/
├── assets/
│   ├── icon.png                 # 128x128 main icon
│   ├── mantiq/                  # Mantiq PNG logos & icon
│   └── nizam/                   # Nizam PNG logos & icon
├── ftdetect/mantiq.lua          # .mq/.nz file type detection
├── ftplugin/
│   ├── mantiq.lua               # Mantiq buffer settings
│   └── nizam.lua                # Nizam buffer settings
├── lua/mantiq/
│   ├── init.lua                 # Plugin setup & parser registration
│   ├── icons.lua                # Devicon & mini.icons integration
│   └── assets.lua               # PNG path resolver & logo viewer
├── plugin/mantiq.lua            # Auto-load on startup & :MantiqLogo
├── queries/mantiq/
│   ├── highlights.scm           # Syntax highlighting queries
│   └── indents.scm              # Auto-indentation queries
└── README.md
```
# nizam-mantiq-nvim
