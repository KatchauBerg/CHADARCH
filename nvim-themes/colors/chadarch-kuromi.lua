-- chadarch-kuromi: Dark purple & pink, gothic cute (Kuromi aesthetic)
-- Palette derived directly from ~/dotfiles/themes/kuromi/colors.sh
-- Part of the CHADARCH dotfiles theming system

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "chadarch-kuromi"
vim.o.termguicolors = true

-- ─── Palette (mirrors kuromi/colors.sh exactly) ───────────────────────────────
local c = {
  bg       = "#1a1025",   -- BASE
  bg_dark  = "#140c1f",   -- MANTLE
  bg_0     = "#0e0818",   -- CRUST
  surface0 = "#2a1f3d",   -- SURFACE0
  surface1 = "#3b2d56",   -- SURFACE1
  surface2 = "#4d3f6e",   -- SURFACE2
  overlay0 = "#6b5f8a",   -- OVERLAY0 — comments
  overlay1 = "#8578a4",   -- OVERLAY1 — line numbers
  overlay2 = "#9f94bb",   -- OVERLAY2

  text     = "#e8dff5",   -- TEXT — lavender-white
  subtext0 = "#c4b8db",   -- SUBTEXT0
  subtext1 = "#d6cce8",   -- SUBTEXT1

  -- Accent palette
  mauve    = "#c084fc",   -- MAUVE   — primary purple  (keywords)
  pink     = "#f472b6",   -- PINK    — hot pink        (functions)
  blue     = "#8b5cf6",   -- BLUE    — deep purple     (imports, special)
  teal     = "#a78bfa",   -- TEAL    — lavender        (types)
  lavender = "#d8b4fe",   -- LAVENDER — light lavender (numbers, constants)
  peach    = "#e8a0bf",   -- PEACH   — pink-peach      (strings)
  red      = "#fb7185",   -- RED     — pink-red        (errors, booleans)
  maroon   = "#f0608e",   -- MAROON  — deep pink
  rosewater= "#f5d0e6",   -- ROSEWATER — palest pink   (constants, markup)
  sky      = "#c4b5fd",   -- SKY     — pale violet
  flamingo = "#f0b6d6",   -- FLAMINGO

  -- Selection / Eclipse-like bg
  sel      = "#3b2d56",   -- surface1 for Visual

  none     = "NONE",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor chrome ────────────────────────────────────────────────────────────
hl("Normal",          { fg = c.text,     bg = c.bg })
hl("NormalNC",        { fg = c.text,     bg = c.bg_dark })
hl("NormalFloat",     { fg = c.text,     bg = c.surface0 })
hl("FloatBorder",     { fg = c.mauve,    bg = c.surface0 })
hl("FloatTitle",      { fg = c.pink,     bg = c.surface0, bold = true })
hl("SignColumn",      { fg = c.overlay0, bg = c.bg })
hl("LineNr",          { fg = c.overlay1 })
hl("CursorLineNr",    { fg = c.mauve,    bold = true })
hl("CursorLine",      { bg = c.surface0 })
hl("CursorColumn",    { bg = c.surface0 })
hl("ColorColumn",     { bg = c.surface1 })
hl("Folded",          { fg = c.overlay0, bg = c.surface0, italic = true })
hl("FoldColumn",      { fg = c.overlay0, bg = c.bg })
hl("VertSplit",       { fg = c.surface2, bg = c.bg })
hl("WinSeparator",    { fg = c.surface2, bg = c.bg })
hl("StatusLine",      { fg = c.subtext1, bg = c.surface1 })
hl("StatusLineNC",    { fg = c.overlay1, bg = c.surface0 })
hl("TabLine",         { fg = c.overlay1, bg = c.surface1 })
hl("TabLineFill",     { fg = c.overlay0, bg = c.bg_dark })
hl("TabLineSel",      { fg = c.pink,     bg = c.surface0, bold = true })

-- ─── Popup menu ───────────────────────────────────────────────────────────────
hl("Pmenu",           { fg = c.text,     bg = c.surface0 })
hl("PmenuSel",        { fg = c.bg,       bg = c.mauve,    bold = true })
hl("PmenuSbar",       { bg = c.surface1 })
hl("PmenuThumb",      { bg = c.mauve })
hl("PmenuBorder",     { fg = c.surface2, bg = c.surface0 })

-- ─── Search & selection ───────────────────────────────────────────────────────
hl("Search",          { fg = c.bg,       bg = c.mauve })
hl("CurSearch",       { fg = c.bg,       bg = c.pink,     bold = true })
hl("IncSearch",       { fg = c.bg,       bg = c.pink })
hl("Visual",          { bg = c.sel })
hl("VisualNOS",       { bg = c.surface1 })
hl("Substitute",      { fg = c.bg,       bg = c.peach })

-- ─── Messages ─────────────────────────────────────────────────────────────────
hl("ModeMsg",         { fg = c.mauve,    bold = true })
hl("MsgArea",         { fg = c.subtext0 })
hl("MoreMsg",         { fg = c.mauve })
hl("WarningMsg",      { fg = c.peach })
hl("ErrorMsg",        { fg = c.red,      bold = true })
hl("Question",        { fg = c.teal })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hl("DiffAdd",         { fg = c.teal,     bg = "#1e1535" })
hl("DiffChange",      { fg = c.mauve,    bg = "#221838" })
hl("DiffDelete",      { fg = c.red,      bg = "#2a1030" })
hl("DiffText",        { fg = c.pink,     bg = "#2d1545", bold = true })

-- ─── Misc ─────────────────────────────────────────────────────────────────────
hl("NonText",         { fg = c.overlay2 })
hl("SpecialKey",      { fg = c.overlay0 })
hl("Whitespace",      { fg = c.surface2 })
hl("Directory",       { fg = c.mauve,    bold = true })
hl("Title",           { fg = c.pink,     bold = true })
hl("MatchParen",      { fg = c.pink,     bg = c.surface1, bold = true })
hl("SpellBad",        { sp = c.red,      undercurl = true })
hl("SpellCap",        { sp = c.peach,    undercurl = true })
hl("SpellLocal",      { sp = c.maroon,   undercurl = true })
hl("SpellRare",       { sp = c.teal,     undercurl = true })
hl("EndOfBuffer",     { fg = c.bg })
hl("Conceal",         { fg = c.overlay0 })

-- ─── Syntax (legacy) ──────────────────────────────────────────────────────────
hl("Comment",         { fg = c.overlay0, italic = true })
hl("Constant",        { fg = c.lavender })
hl("String",          { fg = c.peach })
hl("Character",       { fg = c.peach })
hl("Number",          { fg = c.lavender })
hl("Boolean",         { fg = c.red,      bold = true })
hl("Float",           { fg = c.lavender })
hl("Identifier",      { fg = c.text })
hl("Function",        { fg = c.pink,     bold = true })
hl("Statement",       { fg = c.mauve })
hl("Conditional",     { fg = c.mauve })
hl("Repeat",          { fg = c.mauve })
hl("Label",           { fg = c.teal })
hl("Operator",        { fg = c.subtext0 })
hl("Keyword",         { fg = c.mauve,    bold = true })
hl("Exception",       { fg = c.red,      bold = true })
hl("PreProc",         { fg = c.blue })
hl("Include",         { fg = c.blue })
hl("Define",          { fg = c.blue })
hl("Macro",           { fg = c.sky })
hl("PreCondit",       { fg = c.blue })
hl("Type",            { fg = c.teal })
hl("StorageClass",    { fg = c.mauve })
hl("Structure",       { fg = c.teal })
hl("Typedef",         { fg = c.teal })
hl("Special",         { fg = c.sky })
hl("SpecialChar",     { fg = c.lavender })
hl("Tag",             { fg = c.pink })
hl("Delimiter",       { fg = c.subtext0 })
hl("SpecialComment",  { fg = c.overlay2, italic = true })
hl("Debug",           { fg = c.red })
hl("Underlined",      { underline = true })
hl("Ignore",          { fg = c.overlay0 })
hl("Error",           { fg = c.red,      bold = true, underline = true })
hl("Todo",            { fg = c.bg,       bg = c.mauve, bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hl("@variable",              { fg = c.text })
hl("@variable.builtin",      { fg = c.red,      italic = true })
hl("@variable.parameter",    { fg = c.subtext1 })
hl("@variable.member",       { fg = c.subtext0 })

hl("@constant",              { fg = c.lavender })
hl("@constant.builtin",      { fg = c.lavender, bold = true })
hl("@constant.macro",        { fg = c.sky })

hl("@module",                { fg = c.pink,     italic = true })
hl("@label",                 { fg = c.teal })

hl("@string",                { fg = c.peach })
hl("@string.escape",         { fg = c.lavender })
hl("@string.special",        { fg = c.lavender })
hl("@string.regex",          { fg = c.lavender })

hl("@character",             { fg = c.peach })
hl("@number",                { fg = c.lavender })
hl("@float",                 { fg = c.lavender })
hl("@boolean",               { fg = c.red,      bold = true })

hl("@function",              { fg = c.pink,     bold = true })
hl("@function.builtin",      { fg = c.pink,     italic = true })
hl("@function.call",         { fg = c.pink })
hl("@function.macro",        { fg = c.sky })
hl("@function.method",       { fg = c.pink,     bold = true })
hl("@function.method.call",  { fg = c.pink })

hl("@constructor",           { fg = c.teal })
hl("@operator",              { fg = c.subtext0 })

hl("@keyword",               { fg = c.mauve,    bold = true })
hl("@keyword.function",      { fg = c.mauve,    bold = true })
hl("@keyword.operator",      { fg = c.subtext0 })
hl("@keyword.return",        { fg = c.mauve,    bold = true })
hl("@keyword.import",        { fg = c.blue })
hl("@keyword.conditional",   { fg = c.mauve })
hl("@keyword.repeat",        { fg = c.mauve })
hl("@keyword.exception",     { fg = c.red,      bold = true })

hl("@type",                  { fg = c.teal })
hl("@type.builtin",          { fg = c.teal,     italic = true })
hl("@type.definition",       { fg = c.teal })

hl("@attribute",             { fg = c.blue })
hl("@property",              { fg = c.subtext1 })

hl("@punctuation",           { fg = c.subtext0 })
hl("@punctuation.bracket",   { fg = c.subtext0 })
hl("@punctuation.delimiter", { fg = c.subtext0 })
hl("@punctuation.special",   { fg = c.sky })

hl("@comment",               { fg = c.overlay0, italic = true })
hl("@comment.todo",          { fg = c.bg,       bg = c.mauve,    bold = true })
hl("@comment.note",          { fg = c.bg,       bg = c.teal,     bold = true })
hl("@comment.warning",       { fg = c.bg,       bg = c.peach,    bold = true })
hl("@comment.error",         { fg = c.bg,       bg = c.red,      bold = true })

hl("@tag",                   { fg = c.pink })
hl("@tag.attribute",         { fg = c.teal })
hl("@tag.delimiter",         { fg = c.subtext0 })

hl("@markup.heading",        { fg = c.pink,     bold = true })
hl("@markup.link",           { fg = c.teal,     underline = true })
hl("@markup.link.url",       { fg = c.blue,     underline = true })
hl("@markup.raw",            { fg = c.peach })
hl("@markup.italic",         { fg = c.subtext1, italic = true })
hl("@markup.strong",         { fg = c.rosewater,bold = true })
hl("@markup.list",           { fg = c.mauve })

-- ─── LSP semantic tokens ──────────────────────────────────────────────────────
hl("@lsp.type.class",        { link = "@type" })
hl("@lsp.type.enum",         { link = "@type" })
hl("@lsp.type.function",     { link = "@function" })
hl("@lsp.type.interface",    { link = "@type" })
hl("@lsp.type.keyword",      { link = "@keyword" })
hl("@lsp.type.method",       { link = "@function.method" })
hl("@lsp.type.namespace",    { link = "@module" })
hl("@lsp.type.parameter",    { link = "@variable.parameter" })
hl("@lsp.type.property",     { link = "@property" })
hl("@lsp.type.string",       { link = "@string" })
hl("@lsp.type.struct",       { link = "@type" })
hl("@lsp.type.type",         { link = "@type" })
hl("@lsp.type.variable",     { link = "@variable" })

-- ─── Diagnostics ──────────────────────────────────────────────────────────────
hl("DiagnosticError",              { fg = c.red })
hl("DiagnosticWarn",               { fg = c.peach })
hl("DiagnosticInfo",               { fg = c.teal })
hl("DiagnosticHint",               { fg = c.overlay2 })
hl("DiagnosticOk",                 { fg = c.lavender })
hl("DiagnosticUnderlineError",     { sp = c.red,      undercurl = true })
hl("DiagnosticUnderlineWarn",      { sp = c.peach,    undercurl = true })
hl("DiagnosticUnderlineInfo",      { sp = c.teal,     undercurl = true })
hl("DiagnosticUnderlineHint",      { sp = c.overlay2, undercurl = true })
hl("DiagnosticVirtualTextError",   { fg = c.maroon,   italic = true })
hl("DiagnosticVirtualTextWarn",    { fg = c.overlay2, italic = true })
hl("DiagnosticVirtualTextInfo",    { fg = c.overlay1, italic = true })
hl("DiagnosticVirtualTextHint",    { fg = c.overlay0, italic = true })
hl("LspReferenceText",             { bg = c.surface1 })
hl("LspReferenceRead",             { bg = c.surface1 })
hl("LspReferenceWrite",            { bg = c.surface2 })
hl("LspSignatureActiveParameter",  { fg = c.mauve,    bold = true })
hl("LspInfoBorder",                { fg = c.surface2 })

-- ─── Plugins ──────────────────────────────────────────────────────────────────

-- gitsigns
hl("GitSignsAdd",                  { fg = c.teal })
hl("GitSignsChange",               { fg = c.mauve })
hl("GitSignsDelete",               { fg = c.red })

-- nvim-tree
hl("NvimTreeNormal",               { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeNormalNC",             { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeRootFolder",           { fg = c.pink,     bold = true })
hl("NvimTreeFolderName",           { fg = c.subtext1 })
hl("NvimTreeOpenedFolderName",     { fg = c.mauve,    bold = true })
hl("NvimTreeFolderIcon",           { fg = c.mauve })
hl("NvimTreeFileIcon",             { fg = c.overlay1 })
hl("NvimTreeExecFile",             { fg = c.pink,     bold = true })
hl("NvimTreeGitNew",               { fg = c.teal })
hl("NvimTreeGitDirty",             { fg = c.mauve })
hl("NvimTreeGitDeleted",           { fg = c.red })
hl("NvimTreeSpecialFile",          { fg = c.sky })
hl("NvimTreeIndentMarker",         { fg = c.surface2 })
hl("NvimTreeWinSeparator",         { fg = c.surface2, bg = c.bg_dark })
hl("NvimTreeCursorLine",           { bg = c.surface0 })
hl("NvimTreeSymlink",              { fg = c.teal })
hl("NvimTreeImageFile",            { fg = c.peach })

-- Telescope
hl("TelescopeNormal",              { fg = c.text,     bg = c.surface0 })
hl("TelescopeBorder",              { fg = c.mauve,    bg = c.surface0 })
hl("TelescopePromptNormal",        { fg = c.text,     bg = c.surface1 })
hl("TelescopePromptBorder",        { fg = c.pink,     bg = c.surface1 })
hl("TelescopePromptTitle",         { fg = c.bg,       bg = c.pink,     bold = true })
hl("TelescopePreviewTitle",        { fg = c.bg,       bg = c.mauve,    bold = true })
hl("TelescopeResultsTitle",        { fg = c.mauve,    bg = c.surface0 })
hl("TelescopeMatching",            { fg = c.pink,     bold = true })
hl("TelescopeSelection",           { fg = c.text,     bg = c.sel })
hl("TelescopePromptPrefix",        { fg = c.mauve })
hl("TelescopeMultiSelection",      { fg = c.teal })

-- bufferline
hl("BufferLineFill",               { bg = c.bg_dark })
hl("BufferLineBackground",         { fg = c.overlay1, bg = c.surface1 })
hl("BufferLineSelected",           { fg = c.text,     bg = c.bg,       bold = true })
hl("BufferLineSelectedIndicator",  { fg = c.mauve,    bg = c.bg })
hl("BufferLineModified",           { fg = c.peach,    bg = c.surface1 })
hl("BufferLineModifiedSelected",   { fg = c.peach,    bg = c.bg })
hl("BufferLineSeparator",          { fg = c.bg_dark,  bg = c.surface1 })

-- which-key
hl("WhichKey",                     { fg = c.mauve })
hl("WhichKeyDesc",                 { fg = c.subtext1 })
hl("WhichKeyGroup",                { fg = c.pink,     bold = true })
hl("WhichKeySeparator",            { fg = c.overlay0 })
hl("WhichKeyBorder",               { fg = c.surface2 })
hl("WhichKeyNormal",               { bg = c.surface0 })

-- indent-blankline / mini.indentscope
hl("IblIndent",                    { fg = c.surface1 })
hl("IblScope",                     { fg = c.mauve })
hl("MiniIndentscopeSymbol",        { fg = c.mauve })

-- Snacks (dashboard)
hl("SnacksDashboardHeader",        { fg = c.pink,     bold = true })
hl("SnacksDashboardKey",           { fg = c.mauve })
hl("SnacksDashboardDesc",          { fg = c.subtext0 })
hl("SnacksDashboardIcon",          { fg = c.teal })
hl("SnacksDashboardTitle",         { fg = c.mauve,    bold = true })
hl("SnacksDashboardFooter",        { fg = c.overlay0, italic = true })

-- toggleterm
hl("ToggleTerm1FloatBorder",       { fg = c.mauve,    bg = c.surface0 })
hl("ToggleTermNormal",             { fg = c.text,     bg = c.surface0 })

-- coc.nvim
hl("CocFloating",                  { link = "NormalFloat" })
hl("CocMenuSel",                   { fg = c.bg,       bg = c.mauve,    bold = true })
hl("CocSearch",                    { fg = c.pink,     bold = true })
hl("CocErrorSign",                 { fg = c.red })
hl("CocWarningSign",               { fg = c.peach })
hl("CocInfoSign",                  { fg = c.teal })
hl("CocHintSign",                  { fg = c.overlay2 })
hl("CocErrorHighlight",            { sp = c.red,      undercurl = true })
hl("CocWarningHighlight",          { sp = c.peach,    undercurl = true })
hl("CocHighlightText",             { bg = c.surface1 })
hl("CocCodeLens",                  { fg = c.overlay0, italic = true })
