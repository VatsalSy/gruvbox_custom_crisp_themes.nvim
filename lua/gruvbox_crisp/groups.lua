local M = {}

local function bool(b)
  if b then
    return true
  else
    return nil
  end
end

function M.get(p, o)
  -- guard options and nested tables
  o = o or {}
  local italics = o.italics or {}
  local bold = o.bold or {}
  local transparent = o.transparent
  -- choose intensities
  local sel_lvl = (o.selection_intensity or "high"):lower()
  local selection_bg = (sel_lvl == "low" and p.selection)
    or (sel_lvl == "medium" and p.selection_med)
    or p.selection_high

  local cl_lvl = (o.cursorline_intensity or "subtle"):lower()
  local cursorline_bg = (cl_lvl == "strong" and p.linehl_strong)
    or (cl_lvl == "normal" and p.linehl)
    or p.linehl_subtle

  -- Validate and normalize contrast; keep set consistent with README
  -- Supported: "soft" and "highest" (others coerce to "highest")
  local allowed_contrast = { soft = true, highest = true }
  local contrast = o.contrast
  if type(contrast) == "string" then
    contrast = contrast:lower()
  else
    contrast = "highest"
  end
  if not allowed_contrast[contrast] then
    contrast = "highest"
  end

  -- Base background derived from validated contrast, with transparent override
  local base_bg = (contrast == "soft") and p.bg1 or p.bg0
  if transparent then
    base_bg = p.none
  end

  -- Prepare surface layers for downstream use
  -- Surfaces float above the base background; adjust slightly for "soft".
  local surface1, surface2, surface3
  if contrast == "soft" then
    surface1 = p.bg2
    surface2 = p.bg3
    surface3 = p.bg3
  else
    surface1 = p.bg1
    surface2 = p.bg2
    surface3 = p.bg3
  end

  local groups = {
    -- Core/editor
    Normal = { fg = p.fg0, bg = base_bg },
    NormalNC = { fg = p.fg0, bg = base_bg },
    NormalFloat = { fg = p.fg0, bg = base_bg },
    FloatBorder = { fg = p.border_neutral, bg = base_bg },
    -- VSCode JSON keeps gutter equal to editor background
    SignColumn = { fg = p.fg1, bg = base_bg },
    ColorColumn = { bg = surface1 },
    CursorLine = { bg = cursorline_bg },
    -- Use solid cursor background to work on transparent setups
    Cursor = { bg = p.cursor, bold = true },
    CursorLineNr = { fg = p.line_nr_active, bold = true },
    LineNr = { fg = p.line_nr },
    WinSeparator = { fg = p.border_neutral, bg = base_bg },
    VertSplit = { link = "WinSeparator" },
    StatusLine = { fg = p.ui_fg, bg = base_bg },
    StatusLineNC = { fg = p.gray, bg = base_bg },
    TabLine = { fg = p.gray, bg = base_bg },
    TabLineSel = { fg = p.ui_fg, bg = base_bg, bold = true },
    TabLineFill = { fg = p.gray, bg = base_bg },

    -- Menus / popups
    Pmenu = { fg = p.fg0, bg = surface2 },
    PmenuSel = { fg = p.fg0, bg = p.hover_bg, bold = true },
    PmenuSbar = { bg = surface3 },
    PmenuThumb = { bg = surface3 },

    -- Search / selection
    Search = { fg = p.bg0, bg = p.keyword, bold = true },
    IncSearch = { fg = p.bg0, bg = p.operator, bold = true },
    CurSearch = { link = "IncSearch" },
    Visual = { bg = selection_bg },
    -- VSCode uses a subtle background for matched brackets
    MatchParen = { bg = p.bg2 },

    -- Syntax (vim)
    Comment = { fg = p.comment, italic = bool(italics.comments) },
    String = { fg = p.string, italic = bool(italics.strings) },
    Character = { link = "String" },
    Number = { fg = p.number },
    Boolean = { fg = p.number },
    Float = { link = "Number" },
    Identifier = { fg = p.variable, italic = bool(italics.variables) },
    Function = { fg = p.func, bold = bool(bold.functions), italic = bool(italics.functions) },
    Statement = { fg = p.keyword },
    Conditional = { fg = p.kw_ctrl, italic = bool(italics.keywords) },
    Repeat = { fg = p.kw_ctrl },
    Label = { fg = p.keyword },
    Operator = { fg = p.operator },
    Keyword = { fg = p.keyword, italic = bool(italics.keywords) },
    Exception = { fg = p.keyword },
    PreProc = { fg = p.preproc },
    Include = { fg = p.preproc },
    Define = { fg = p.preproc },
    Macro = { fg = p.preproc },
    PreCondit = { fg = p.kw_ctrl },
    Type = { fg = p.type },
    StorageClass = { fg = p.kw_ctrl },
    Structure = { fg = p.kw_ctrl },
    Typedef = { fg = p.kw_ctrl },
    Special = { fg = p.link },
    SpecialChar = { fg = p.link },
    Tag = { fg = p.operator },
    Delimiter = { fg = p.punct },
    SpecialComment = { fg = p.comment, italic = bool(italics.comments) },
    Debug = { fg = p.red },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },

    -- Messages
    Error = { fg = p.red, bold = true },
    WarningMsg = { fg = p.warn },
    ErrorMsg = { fg = p.red, bold = true },
    HintMsg = { fg = p.hint },
    Todo = { fg = p.operator, bold = true },

    -- Diff / VCS
    DiffAdd = { fg = p.green, bg = p.diff_add_bg },
    DiffChange = { fg = p.warn, bg = p.bg2 },
    DiffDelete = { fg = p.red, bg = p.diff_delete_bg },
    DiffText = { fg = p.diff_text, bg = p.bg2, bold = true },
    GitSignsAdd = { fg = p.green },
    GitSignsChange = { fg = p.warn },
    GitSignsDelete = { fg = p.red },

    -- Diagnostics
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticOk = { fg = p.ok },
    -- Signs (signcolumn)
    DiagnosticSignError = { link = "DiagnosticError" },
    DiagnosticSignWarn = { link = "DiagnosticWarn" },
    DiagnosticSignInfo = { link = "DiagnosticInfo" },
    DiagnosticSignHint = { link = "DiagnosticHint" },
    DiagnosticSignOk = { link = "DiagnosticOk" },
    -- Virtual text
    DiagnosticVirtualTextError = transparent and { fg = p.red } or { fg = p.red, bg = surface1 },
    DiagnosticVirtualTextWarn = transparent and { fg = p.warn } or { fg = p.warn, bg = surface1 },
    DiagnosticVirtualTextInfo = transparent and { fg = p.info } or { fg = p.info, bg = surface1 },
    DiagnosticVirtualTextHint = transparent and { fg = p.hint } or { fg = p.hint, bg = surface1 },
    DiagnosticVirtualTextOk = transparent and { fg = p.ok } or { fg = p.ok, bg = surface1 },
    -- Undercurls
    DiagnosticUnderlineError = { sp = p.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.warn, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.hint, undercurl = true },

    -- LSP/UX
    LspReferenceText = { bg = p.hover_bg },
    LspReferenceRead = { bg = p.hover_bg },
    LspReferenceWrite = { bg = p.hover_bg },
    LspCodeLens = { fg = p.comment },
    LspInlayHint = { fg = p.comment, bg = p.none },

    -- Treesitter/Semantic tokens (common)
    ["@comment"] = { link = "Comment" },
    ["@string"] = { link = "String" },
    ["@number"] = { link = "Number" },
    ["@constant.numeric"] = { link = "Number" },
    ["@boolean"] = { link = "Boolean" },
    ["@constant"] = { fg = p.const },
    ["@constant.builtin"] = { fg = p.preproc },
    ["@constant.macro"] = { fg = p.const },
    ["@variable"] = { fg = p.variable },
    ["@variable.parameter"] = { fg = p.property },
    ["@field"] = { fg = p.property },
    ["@property"] = { fg = p.property },
    ["@function"] = { fg = p.func }, -- Use pink for functions
    ["@function.call"] = { fg = p.func_green }, -- Function calls in green
    ["@method"] = { fg = p.func },
    ["@method.call"] = { fg = p.func_green },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.conditional"] = { fg = p.kw_ctrl },
    ["@keyword.repeat"] = { fg = p.kw_ctrl },
    ["@keyword.return"] = { fg = p.kw_ctrl },
    ["@keyword.exception"] = { fg = p.kw_ctrl },
    ["@keyword.import"] = { fg = p.kw_ctrl }, -- Python import/from keywords
    ["@keyword.directive"] = { fg = p.preproc },
    ["@operator"] = { link = "Operator" },
    ["@punctuation"] = { fg = p.punct },
    ["@punctuation.bracket"] = { fg = p.punct },
    ["@punctuation.delimiter"] = { fg = p.punct },
    ["@punctuation.special"] = { fg = p.operator },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { link = "Type" },
    ["@namespace"] = { fg = p.number }, -- bright purple
    ["@type.parameter"] = { link = "Type" },
    ["@attribute"] = { fg = p.decorator },

    -- Python-specific highlights
    ["@decorator.python"] = { fg = p.decorator },
    ["@variable.language.self.python"] = { link = "@variable.parameter" },
    ["@variable.language.cls.python"] = { link = "@variable.parameter" },
    ["@function.builtin.python"] = { fg = p.preproc },
    ["@function.magic.python"] = { fg = p.magic },
    ["@string.documentation.python"] = { fg = p.comment, italic = bool(italics.comments) },
    ["@type.annotation.python"] = { fg = p.type },
    ["@keyword.storage.python"] = { link = "@keyword" }, -- class, def, async
    ["@parameter.python"] = { fg = p.property },

    -- LaTeX-specific highlights (modern Treesitter queries)
    ["@function.latex"] = { fg = p.func_green }, -- LaTeX commands like \section
    ["@function.macro.latex"] = { fg = p.func_green }, -- LaTeX macros
    ["@function.builtin.latex"] = { fg = p.func_green }, -- Built-in LaTeX commands
    ["@keyword.latex"] = { fg = p.kw_ctrl }, -- LaTeX keywords
    ["@keyword.control.latex"] = { fg = p.kw_ctrl }, -- \begin, \end
    ["@keyword.import.latex"] = { fg = p.func_green }, -- \usepackage, \documentclass should be green
    ["@text.math.latex"] = { fg = p.latex_math }, -- Math mode
    ["@text.environment.latex"] = { fg = p.type }, -- Environment names
    ["@text.environment.name.latex"] = { fg = p.type }, -- Environment names in \begin{}
    ["@parameter.latex"] = { fg = p.const }, -- Parameters in brackets
    ["@variable.parameter.latex"] = { fg = p.const }, -- Command parameters
    ["@punctuation.special.latex"] = { fg = p.kw_ctrl }, -- Special LaTeX punctuation
    ["@punctuation.bracket.latex"] = { fg = p.punct }, -- Brackets in LaTeX
    ["@comment.latex"] = { fg = p.latex_comment, italic = bool(italics.comments) },
    ["@comment.line.percentage.latex"] = { fg = p.latex_comment, italic = bool(italics.comments) },
    ["@string.latex"] = { fg = p.string }, -- String content in LaTeX

    -- Additional LaTeX support (older/alternative queries)
    -- NOTE: Some capture names below (e.g., module/support/entity) are
    -- nonstandard or editor-specific. We keep them (harmless if absent) and
    -- also provide LSP semantic-token fallbacks for texlab-enabled setups.
    ["@text.literal.latex"] = { fg = p.string },
    ["@text.reference.latex"] = { fg = p.const }, -- \ref, \cite
    ["@text.title.latex"] = { fg = p.latex_math, bold = true }, -- Section titles
    ["@markup.math.latex"] = { fg = p.latex_math }, -- Math content
    ["@markup.raw.latex"] = { fg = p.string }, -- Verbatim/raw text
    ["@module.latex"] = { fg = p.type }, -- Package names
    ["@namespace.latex"] = { fg = p.type }, -- Namespaces
    ["@support.function.latex"] = { fg = p.func_green }, -- Support functions
    ["@entity.name.latex"] = { fg = p.entity_name },

    -- LSP semantic-token fallbacks (texlab)
    ["@lsp.type.module.latex"] = { fg = p.type },
    ["@lsp.type.namespace.latex"] = { fg = p.type },
    ["@lsp.type.function.latex"] = { fg = p.func_green },

    -- Treesitter: Markdown/markup
    ["@markup.heading"] = { fg = p.keyword, bold = true },
    ["@markup.heading.1"] = { fg = p.keyword, bold = true },
    ["@markup.heading.2"] = { fg = p.keyword, bold = true },
    ["@markup.heading.3"] = { fg = p.keyword, bold = true },
    ["@markup.heading.4"] = { fg = p.keyword, bold = true },
    ["@markup.heading.5"] = { fg = p.keyword, bold = true },
    ["@markup.heading.6"] = { fg = p.keyword, bold = true },
    ["@markup.strong"] = { fg = p.fg0, bold = true },
    ["@markup.italic"] = { fg = p.fg0, italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.link"] = { fg = p.link },
    ["@markup.link.url"] = { fg = p.link, underline = true },
    ["@markup.link.label"] = { fg = p.link_active },
    ["@string.special.url"] = { fg = p.link, underline = true },
    ["@markup.raw"] = { fg = p.string }, -- inline code
    ["@markup.raw.block"] = transparent and { fg = p.string } or { fg = p.string, bg = surface2 }, -- code block
    ["@markup.list"] = { fg = p.operator },
    ["@markup.quote"] = { fg = p.comment },

    -- Legacy Vim markdown (fallback when no Treesitter)
    Title = { fg = p.keyword, bold = true },
    markdownH1 = { link = "Title" },
    markdownH2 = { link = "Title" },
    markdownH3 = { link = "Title" },
    markdownH4 = { link = "Title" },
    markdownH5 = { link = "Title" },
    markdownH6 = { link = "Title" },
    markdownHeadingDelimiter = { fg = p.decorator },
    markdownBold = { bold = true },
    markdownItalic = { italic = true },
    markdownCode = { fg = p.string },
    markdownCodeBlock = transparent and { fg = p.string } or { fg = p.string, bg = surface2 },
    markdownUrl = { fg = p.link, underline = true },
    markdownLinkText = { fg = p.link_active },
    markdownListMarker = { fg = p.operator },
    markdownRule = { fg = p.border_focus },
    markdownBlockquote = { fg = p.comment },

    -- Legacy LaTeX syntax highlighting (non-Treesitter)
    texCmd = { fg = p.func_green }, -- LaTeX commands
    texCmdName = { fg = p.func_green },
    texFunction = { fg = p.func_green },
    texStatement = { fg = p.kw_ctrl }, -- \begin, \end, etc
    texBeginEnd = { fg = p.kw_ctrl },
    texBeginEndName = { fg = p.type }, -- Environment names
    texDocType = { fg = p.func_green }, -- \documentclass should be green
    texDocTypeArgs = { fg = p.type },
    texInputFile = { fg = p.func_green }, -- \usepackage, \input should be green
    texSection = { fg = p.func_green }, -- Section commands
    texSectionName = { fg = p.latex_math, bold = true },
    texTitle = { fg = p.latex_math, bold = true },
    texMathZone = { fg = p.latex_math }, -- Math zones
    texMathOper = { fg = p.latex_math },
    texMathDelim = { fg = p.operator },
    texGreek = { fg = p.latex_math },
    texComment = { fg = p.latex_comment, italic = bool(italics.comments) },
    texString = { fg = p.string },
    texRefZone = { fg = p.const }, -- References
    texCite = { fg = p.const }, -- Citations
    texNewCmd = { fg = p.func_green }, -- \newcommand
    texCmdArgs = { fg = p.property }, -- Command arguments
    texOpt = { fg = p.property }, -- Optional arguments

    ["@class"] = { fg = p.type }, -- Class names should be cyan
    ["@interface"] = { fg = p.type },
    ["@enum"] = { fg = p.keyword }, -- Enums as yellow
    ["@enumMember"] = { fg = p.const }, -- Enum members as mauve
    -- Standard LSP semantic tokens
    ["@lsp.type.class"] = { fg = p.type },
    ["@lsp.type.interface"] = { fg = p.type },
    ["@lsp.type.enum"] = { fg = p.keyword },
    ["@lsp.type.enumMember"] = { fg = p.const },
  }

  for k, v in pairs(o.overrides or {}) do
    groups[k] = v
  end

  return groups
end

return M
