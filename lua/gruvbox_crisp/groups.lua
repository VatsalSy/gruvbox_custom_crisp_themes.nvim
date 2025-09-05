local M = {}

local function bool(b)
  if b then return true else return nil end
end

function M.get(p, o)
  local transparent = o.transparent

  local groups = {
    -- Core/editor
    Normal       = { fg = p.fg0, bg = transparent and p.none or p.bg0 },
    NormalNC     = { fg = p.fg0, bg = transparent and p.none or p.bg0 },
    NormalFloat  = { fg = p.fg0, bg = transparent and p.none or p.bg0 },
    FloatBorder  = { fg = p.border_neutral, bg = transparent and p.none or p.bg0 },
    SignColumn   = { fg = p.fg1, bg = transparent and p.none or p.bg1 },
    ColorColumn  = { bg = p.bg1 },
    CursorLine   = { bg = p.bg1 },
    Cursor       = { fg = p.bg0, bg = p.cursor, bold = true },
    CursorLineNr = { fg = p.line_nr_active, bold = true },
    LineNr       = { fg = p.line_nr },
    WinSeparator = { fg = p.border_neutral, bg = transparent and p.none or p.bg0 },
    VertSplit    = { link = "WinSeparator" },
    StatusLine   = { fg = p.ui_fg, bg = p.bg0 },
    StatusLineNC = { fg = p.gray, bg = p.bg0 },
    TabLine      = { fg = p.gray, bg = p.bg0 },
    TabLineSel   = { fg = p.ui_fg, bg = p.bg0, bold = true },
    TabLineFill  = { fg = p.gray, bg = p.bg0 },

    -- Menus / popups
    Pmenu        = { fg = p.fg0, bg = p.bg0 },
    PmenuSel     = { fg = p.fg0, bg = p.hover_bg, bold = true },
    PmenuSbar    = { bg = p.bg2 },
    PmenuThumb   = { bg = p.bg3 },

    -- Search / selection
    Search       = { fg = p.bg0, bg = p.keyword, bold = true },
    IncSearch    = { fg = p.bg0, bg = p.operator, bold = true },
    CurSearch    = { link = "IncSearch" },
    Visual       = { bg = p.selection },
    MatchParen   = { fg = p.decorator, bold = true },

    -- Syntax (vim)
    Comment      = { fg = p.comment, italic = bool(o.italics.comments) },
    String       = { fg = p.string, italic = bool(o.italics.strings) },
    Character    = { link = "String" },
    Number       = { fg = p.number },
    Boolean      = { fg = p.number },
    Float        = { link = "Number" },
    Identifier   = { fg = p.variable, italic = bool(o.italics.variables) },
    Function     = { fg = p.func, bold = bool(o.bold.functions), italic = bool(o.italics.functions) },
    Statement    = { fg = p.keyword },
    Conditional  = { fg = p.keyword, italic = bool(o.italics.keywords) },
    Repeat       = { fg = p.keyword },
    Label        = { fg = p.keyword },
    Operator     = { fg = p.operator },
    Keyword      = { fg = p.keyword, italic = bool(o.italics.keywords) },
    Exception    = { fg = p.keyword },
    PreProc      = { fg = p.decorator },
    Include      = { fg = p.decorator },
    Define       = { fg = p.decorator },
    Macro        = { fg = p.decorator },
    PreCondit    = { fg = p.decorator },
    Type         = { fg = p.type },
    StorageClass = { fg = p.type },
    Structure    = { fg = p.type },
    Typedef      = { fg = p.type },
    Special      = { fg = p.link },
    SpecialChar  = { fg = p.link },
    Tag          = { fg = p.operator },
    Delimiter    = { fg = p.gray },
    SpecialComment = { fg = p.comment, italic = bool(o.italics.comments) },
    Debug        = { fg = p.red },
    Underlined   = { underline = true },
    Bold         = { bold = true },
    Italic       = { italic = true },

    -- Messages
    Error        = { fg = p.red, bold = true },
    WarningMsg   = { fg = p.warn },
    ErrorMsg     = { fg = p.red, bold = true },
    HintMsg      = { fg = p.hint },
    Todo         = { fg = p.operator, bold = true },

    -- Diff / VCS
    DiffAdd      = { fg = p.green, bg = p.diff_add_bg },
    DiffChange   = { fg = p.warn,  bg = p.bg2 },
    DiffDelete   = { fg = p.red,   bg = p.diff_delete_bg },
    DiffText     = { fg = p.diff_text, bg = p.bg2, bold = true },
    GitSignsAdd    = { fg = p.green },
    GitSignsChange = { fg = p.warn },
    GitSignsDelete = { fg = p.red },

    -- Diagnostics
    DiagnosticError = { fg = "#fb4934" },
    DiagnosticWarn  = { fg = "#d79921" },
    DiagnosticInfo  = { fg = "#83a598" },
    DiagnosticHint  = { fg = p.hint },
    DiagnosticOk    = { fg = p.ok },
    DiagnosticUnderlineError = { sp = p.red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = p.warn, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = p.info, undercurl = true },
    DiagnosticUnderlineHint  = { sp = p.hint, undercurl = true },

    -- LSP/UX
    LspReferenceText  = { bg = p.hover_bg },
    LspReferenceRead  = { bg = p.hover_bg },
    LspReferenceWrite = { bg = p.hover_bg },
    LspCodeLens       = { fg = p.comment },
    LspInlayHint      = { fg = p.comment, bg = p.bg0 },

    -- Treesitter/Semantic tokens (common)
    ["@comment"]        = { link = "Comment" },
    ["@string"]         = { link = "String" },
    ["@number"]         = { link = "Number" },
    ["@boolean"]        = { link = "Boolean" },
    ["@constant"]       = { fg = p.number },
    ["@variable"]       = { fg = p.variable },
    ["@variable.parameter"] = { fg = p.variable },
    ["@field"]          = { fg = p.variable },
    ["@function"]       = { link = "Function" },
    ["@method"]         = { link = "Function" },
    ["@keyword"]        = { link = "Keyword" },
    ["@operator"]       = { link = "Operator" },
    ["@punctuation"]    = { fg = p.gray },
    ["@punctuation.bracket"] = { fg = p.gray },
    ["@punctuation.delimiter"] = { fg = p.gray },
    ["@punctuation.special"]   = { fg = p.operator },
    ["@type"]           = { link = "Type" },
    ["@type.builtin"]   = { link = "Type" },
    ["@namespace"]      = { fg = p.number }, -- bright purple
    ["@typeParameter"]  = { link = "Type" },
    ["@attribute"]      = { fg = p.decorator },

    -- Treesitter: Markdown/markup
    ["@markup.heading"]        = { fg = p.keyword, bold = true },
    ["@markup.heading.1"]      = { fg = p.keyword, bold = true },
    ["@markup.heading.2"]      = { fg = p.keyword, bold = true },
    ["@markup.heading.3"]      = { fg = p.keyword, bold = true },
    ["@markup.heading.4"]      = { fg = p.keyword, bold = true },
    ["@markup.heading.5"]      = { fg = p.keyword, bold = true },
    ["@markup.heading.6"]      = { fg = p.keyword, bold = true },
    ["@markup.strong"]         = { fg = p.fg0, bold = true },
    ["@markup.italic"]         = { fg = p.fg0, italic = true },
    ["@markup.strikethrough"]  = { strikethrough = true },
    ["@markup.link"]           = { fg = p.link },
    ["@markup.link.url"]       = { fg = p.link, underline = true },
    ["@markup.link.label"]     = { fg = p.link_active },
    ["@string.special.url"]    = { fg = p.link, underline = true },
    ["@markup.raw"]            = { fg = p.string }, -- inline code
    ["@markup.raw.block"]      = { fg = p.string, bg = p.bg1 }, -- code block
    ["@markup.list"]           = { fg = p.operator },
    ["@markup.quote"]          = { fg = p.comment },
    ["@punctuation.special"]   = { fg = p.operator }, -- e.g., list markers

    -- Legacy Vim markdown (fallback when no Treesitter)
    Title                       = { fg = p.keyword, bold = true },
    markdownH1                  = { link = "Title" },
    markdownH2                  = { link = "Title" },
    markdownH3                  = { link = "Title" },
    markdownH4                  = { link = "Title" },
    markdownH5                  = { link = "Title" },
    markdownH6                  = { link = "Title" },
    markdownHeadingDelimiter    = { fg = p.decorator },
    markdownBold                = { bold = true },
    markdownItalic              = { italic = true },
    markdownCode                = { fg = p.string },
    markdownCodeBlock           = { fg = p.string, bg = p.bg1 },
    markdownUrl                 = { fg = p.link, underline = true },
    markdownLinkText            = { fg = p.link_active },
    markdownListMarker          = { fg = p.operator },
    markdownRule                = { fg = p.border_focus },
    markdownBlockquote          = { fg = p.comment },

    -- UI links
    Underlined         = { fg = p.link, underline = true },
  }

  for k, v in pairs(o.overrides or {}) do
    groups[k] = v
  end

  return groups
end

return M
