-- chadarch-hacking: Black & Red matrix/hacker aesthetic
-- Part of the CHADARCH dotfiles theming system

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "chadarch-hacking"
vim.o.termguicolors = true

local c = {
  bg       = "#0a0a0a",
  bg_dark  = "#060606",
  bg_0     = "#000000",
  surface0 = "#1a1a1a",
  surface1 = "#252525",
  surface2 = "#333333",
  overlay0 = "#4a4a4a",
  overlay1 = "#5c5c5c",
  overlay2 = "#6e6e6e",
  text     = "#d0d0d0",
  subtext0 = "#a0a0a0",
  subtext1 = "#b8b8b8",
  red      = "#ff0000",
  red_br   = "#ff1744",
  red_dk   = "#d50000",
  red_dim  = "#c62828",
  orange   = "#ff3d00",
  pink     = "#ff4081",
  maroon   = "#b71c1c",
  none     = "NONE",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor chrome ───────────────────────────────────────────────────────────
hl("Normal",          { fg = c.text,     bg = c.bg })
hl("NormalNC",        { fg = c.text,     bg = c.bg_dark })
hl("NormalFloat",     { fg = c.text,     bg = c.surface0 })
hl("FloatBorder",     { fg = c.red_dk,   bg = c.surface0 })
hl("FloatTitle",      { fg = c.red,      bg = c.surface0, bold = true })
hl("SignColumn",      { fg = c.overlay0, bg = c.bg })
hl("LineNr",          { fg = c.overlay1 })
hl("CursorLineNr",    { fg = c.red,      bold = true })
hl("CursorLine",      { bg = c.surface0 })
hl("CursorColumn",    { bg = c.surface0 })
hl("ColorColumn",     { bg = c.surface1 })
hl("Folded",          { fg = c.overlay0, bg = c.surface0 })
hl("FoldColumn",      { fg = c.overlay0, bg = c.bg })
hl("VertSplit",       { fg = c.surface2, bg = c.bg })
hl("WinSeparator",    { fg = c.surface2, bg = c.bg })
hl("StatusLine",      { fg = c.subtext1, bg = c.surface0 })
hl("StatusLineNC",    { fg = c.overlay1, bg = c.surface1 })
hl("TabLine",         { fg = c.overlay1, bg = c.surface1 })
hl("TabLineFill",     { fg = c.overlay0, bg = c.bg_dark })
hl("TabLineSel",      { fg = c.red,      bg = c.surface0, bold = true })

-- ─── Popup menu ──────────────────────────────────────────────────────────────
hl("Pmenu",           { fg = c.text,     bg = c.surface0 })
hl("PmenuSel",        { fg = c.bg,       bg = c.red,      bold = true })
hl("PmenuSbar",       { bg = c.surface1 })
hl("PmenuThumb",      { bg = c.red_dk })
hl("PmenuBorder",     { fg = c.surface2, bg = c.surface0 })

-- ─── Search & selection ───────────────────────────────────────────────────────
hl("Search",          { fg = c.bg,       bg = c.red })
hl("CurSearch",       { fg = c.bg,       bg = c.red_br,   bold = true })
hl("IncSearch",       { fg = c.bg,       bg = c.red_br })
hl("Visual",          { bg = c.surface2 })
hl("VisualNOS",       { bg = c.surface1 })
hl("Substitute",      { fg = c.bg,       bg = c.orange })

-- ─── Messages ────────────────────────────────────────────────────────────────
hl("ModeMsg",         { fg = c.red,      bold = true })
hl("MsgArea",         { fg = c.subtext0 })
hl("MoreMsg",         { fg = c.red_br })
hl("WarningMsg",      { fg = c.orange })
hl("ErrorMsg",        { fg = c.red_br,   bold = true })
hl("Question",        { fg = c.red })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hl("DiffAdd",         { fg = c.red_br,   bg = "#1a0a0a" })
hl("DiffChange",      { fg = c.orange,   bg = "#150a00" })
hl("DiffDelete",      { fg = c.red_dk,   bg = "#1a0000" })
hl("DiffText",        { fg = c.orange,   bg = "#2a1000", bold = true })

-- ─── Misc ─────────────────────────────────────────────────────────────────────
hl("NonText",         { fg = c.overlay2 })
hl("SpecialKey",      { fg = c.overlay0 })
hl("Whitespace",      { fg = c.surface2 })
hl("Directory",       { fg = c.red,      bold = true })
hl("Title",           { fg = c.red,      bold = true })
hl("MatchParen",      { fg = c.red_br,   bg = c.surface1, bold = true })
hl("SpellBad",        { sp = c.red,      undercurl = true })
hl("SpellCap",        { sp = c.orange,   undercurl = true })
hl("SpellLocal",      { sp = c.maroon,   undercurl = true })
hl("SpellRare",       { sp = c.pink,     undercurl = true })
hl("EndOfBuffer",     { fg = c.bg })
hl("Conceal",         { fg = c.overlay0 })

-- ─── Syntax (legacy groups) ───────────────────────────────────────────────────
hl("Comment",         { fg = c.overlay0, italic = true })
hl("Constant",        { fg = c.maroon })
hl("String",          { fg = c.red_dk })
hl("Character",       { fg = c.red_dk })
hl("Number",          { fg = c.orange })
hl("Boolean",         { fg = c.red,      bold = true })
hl("Float",           { fg = c.orange })
hl("Identifier",      { fg = c.text })
hl("Function",        { fg = c.red_br,   bold = true })
hl("Statement",       { fg = c.red })
hl("Conditional",     { fg = c.red })
hl("Repeat",          { fg = c.red })
hl("Label",           { fg = c.pink })
hl("Operator",        { fg = c.subtext1 })
hl("Keyword",         { fg = c.red,      bold = true })
hl("Exception",       { fg = c.red_br })
hl("PreProc",         { fg = c.pink })
hl("Include",         { fg = c.pink })
hl("Define",          { fg = c.pink })
hl("Macro",           { fg = c.orange })
hl("PreCondit",       { fg = c.pink })
hl("Type",            { fg = c.orange })
hl("StorageClass",    { fg = c.red })
hl("Structure",       { fg = c.orange })
hl("Typedef",         { fg = c.orange })
hl("Special",         { fg = c.pink })
hl("SpecialChar",     { fg = c.orange })
hl("Tag",             { fg = c.red_br })
hl("Delimiter",       { fg = c.subtext0 })
hl("SpecialComment",  { fg = c.overlay2, italic = true })
hl("Debug",           { fg = c.red_br })
hl("Underlined",      { underline = true })
hl("Ignore",          { fg = c.overlay0 })
hl("Error",           { fg = c.red_br,   bold = true, underline = true })
hl("Todo",            { fg = c.bg,       bg = c.red,  bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hl("@variable",              { fg = c.text })
hl("@variable.builtin",      { fg = c.red,      italic = true })
hl("@variable.parameter",    { fg = c.subtext1 })
hl("@variable.member",       { fg = c.subtext0 })

hl("@constant",              { fg = c.maroon })
hl("@constant.builtin",      { fg = c.red,      bold = true })
hl("@constant.macro",        { fg = c.orange })

hl("@module",                { fg = c.orange,   bold = true })
hl("@label",                 { fg = c.pink })

hl("@string",                { fg = c.red_dk })
hl("@string.escape",         { fg = c.orange })
hl("@string.special",        { fg = c.orange })
hl("@string.regex",          { fg = c.orange })

hl("@character",             { fg = c.red_dk })
hl("@number",                { fg = c.orange })
hl("@float",                 { fg = c.orange })
hl("@boolean",               { fg = c.red,      bold = true })

hl("@function",              { fg = c.red_br,   bold = true })
hl("@function.builtin",      { fg = c.red_br,   italic = true })
hl("@function.call",         { fg = c.red_br })
hl("@function.macro",        { fg = c.orange })
hl("@function.method",       { fg = c.red_br })
hl("@function.method.call",  { fg = c.red_br })

hl("@constructor",           { fg = c.orange })
hl("@operator",              { fg = c.subtext1 })

hl("@keyword",               { fg = c.red,      bold = true })
hl("@keyword.function",      { fg = c.red,      bold = true })
hl("@keyword.operator",      { fg = c.subtext1 })
hl("@keyword.return",        { fg = c.red_br,   bold = true })
hl("@keyword.import",        { fg = c.pink })
hl("@keyword.conditional",   { fg = c.red })
hl("@keyword.repeat",        { fg = c.red })
hl("@keyword.exception",     { fg = c.red_br })

hl("@type",                  { fg = c.orange })
hl("@type.builtin",          { fg = c.orange,   italic = true })
hl("@type.definition",       { fg = c.orange })

hl("@attribute",             { fg = c.pink })
hl("@property",              { fg = c.subtext0 })

hl("@punctuation",           { fg = c.subtext0 })
hl("@punctuation.bracket",   { fg = c.subtext0 })
hl("@punctuation.delimiter", { fg = c.subtext0 })
hl("@punctuation.special",   { fg = c.orange })

hl("@comment",               { fg = c.overlay0, italic = true })
hl("@comment.todo",          { fg = c.bg,       bg = c.red,    bold = true })
hl("@comment.note",          { fg = c.bg,       bg = c.maroon, bold = true })
hl("@comment.warning",       { fg = c.bg,       bg = c.orange, bold = true })
hl("@comment.error",         { fg = c.bg,       bg = c.red_br, bold = true })

hl("@tag",                   { fg = c.red })
hl("@tag.attribute",         { fg = c.orange })
hl("@tag.delimiter",         { fg = c.subtext0 })

hl("@markup.heading",        { fg = c.red,      bold = true })
hl("@markup.link",           { fg = c.red_br,   underline = true })
hl("@markup.link.url",       { fg = c.maroon,   underline = true })
hl("@markup.raw",            { fg = c.orange })
hl("@markup.italic",         { fg = c.subtext1, italic = true })
hl("@markup.strong",         { fg = c.text,     bold = true })
hl("@markup.list",           { fg = c.red })

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

-- ─── Diagnostics ─────────────────────────────────────────────────────────────
hl("DiagnosticError",              { fg = c.red_br })
hl("DiagnosticWarn",               { fg = c.orange })
hl("DiagnosticInfo",               { fg = c.subtext1 })
hl("DiagnosticHint",               { fg = c.overlay2 })
hl("DiagnosticOk",                 { fg = c.maroon })
hl("DiagnosticUnderlineError",     { sp = c.red_br,   undercurl = true })
hl("DiagnosticUnderlineWarn",      { sp = c.orange,   undercurl = true })
hl("DiagnosticUnderlineInfo",      { sp = c.subtext1, undercurl = true })
hl("DiagnosticUnderlineHint",      { sp = c.overlay2, undercurl = true })
hl("DiagnosticVirtualTextError",   { fg = c.red_dk,   italic = true })
hl("DiagnosticVirtualTextWarn",    { fg = c.maroon,   italic = true })
hl("DiagnosticVirtualTextInfo",    { fg = c.overlay1, italic = true })
hl("DiagnosticVirtualTextHint",    { fg = c.overlay0, italic = true })
hl("LspReferenceText",             { bg = c.surface1 })
hl("LspReferenceRead",             { bg = c.surface1 })
hl("LspReferenceWrite",            { bg = c.surface2 })
hl("LspSignatureActiveParameter",  { fg = c.red_br,   bold = true })
hl("LspInfoBorder",                { fg = c.surface2 })

-- ─── Plugins ──────────────────────────────────────────────────────────────────

-- gitsigns
hl("GitSignsAdd",                  { fg = c.red_br })
hl("GitSignsChange",               { fg = c.orange })
hl("GitSignsDelete",               { fg = c.red_dk })

-- nvim-tree
hl("NvimTreeNormal",               { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeNormalNC",             { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeRootFolder",           { fg = c.red,      bold = true })
hl("NvimTreeFolderName",           { fg = c.subtext1 })
hl("NvimTreeOpenedFolderName",     { fg = c.red,      bold = true })
hl("NvimTreeFolderIcon",           { fg = c.red_dk })
hl("NvimTreeFileIcon",             { fg = c.overlay1 })
hl("NvimTreeExecFile",             { fg = c.red_br,   bold = true })
hl("NvimTreeGitNew",               { fg = c.red_br })
hl("NvimTreeGitDirty",             { fg = c.orange })
hl("NvimTreeGitDeleted",           { fg = c.red_dk })
hl("NvimTreeSpecialFile",          { fg = c.pink })
hl("NvimTreeIndentMarker",         { fg = c.surface2 })
hl("NvimTreeWinSeparator",         { fg = c.surface2, bg = c.bg_dark })
hl("NvimTreeCursorLine",           { bg = c.surface0 })
hl("NvimTreeSymlink",              { fg = c.pink })
hl("NvimTreeImageFile",            { fg = c.pink })

-- Telescope
hl("TelescopeNormal",              { fg = c.text,     bg = c.surface0 })
hl("TelescopeBorder",              { fg = c.red_dk,   bg = c.surface0 })
hl("TelescopePromptNormal",        { fg = c.text,     bg = c.surface1 })
hl("TelescopePromptBorder",        { fg = c.red,      bg = c.surface1 })
hl("TelescopePromptTitle",         { fg = c.bg,       bg = c.red,    bold = true })
hl("TelescopePreviewTitle",        { fg = c.bg,       bg = c.red_dk, bold = true })
hl("TelescopeResultsTitle",        { fg = c.red_dk,   bg = c.surface0 })
hl("TelescopeMatching",            { fg = c.red_br,   bold = true })
hl("TelescopeSelection",           { fg = c.text,     bg = c.surface2 })
hl("TelescopePromptPrefix",        { fg = c.red })
hl("TelescopeMultiSelection",      { fg = c.orange })

-- bufferline
hl("BufferLineFill",               { bg = c.bg_dark })
hl("BufferLineBackground",         { fg = c.overlay1, bg = c.surface1 })
hl("BufferLineSelected",           { fg = c.text,     bg = c.bg,     bold = true })
hl("BufferLineSelectedIndicator",  { fg = c.red,      bg = c.bg })
hl("BufferLineModified",           { fg = c.orange,   bg = c.surface1 })
hl("BufferLineModifiedSelected",   { fg = c.orange,   bg = c.bg })
hl("BufferLineSeparator",          { fg = c.bg_dark,  bg = c.surface1 })

-- which-key
hl("WhichKey",                     { fg = c.red })
hl("WhichKeyDesc",                 { fg = c.subtext1 })
hl("WhichKeyGroup",                { fg = c.orange,   bold = true })
hl("WhichKeySeparator",            { fg = c.overlay0 })
hl("WhichKeyBorder",               { fg = c.surface2 })
hl("WhichKeyNormal",               { bg = c.surface0 })

-- indent-blankline / mini.indentscope
hl("IblIndent",                    { fg = c.surface1 })
hl("IblScope",                     { fg = c.red_dk })
hl("MiniIndentscopeSymbol",        { fg = c.red_dk })

-- Snacks (dashboard)
hl("SnacksDashboardHeader",        { fg = c.red,      bold = true })
hl("SnacksDashboardKey",           { fg = c.red_br })
hl("SnacksDashboardDesc",          { fg = c.subtext0 })
hl("SnacksDashboardIcon",          { fg = c.red_dk })
hl("SnacksDashboardTitle",         { fg = c.red })
hl("SnacksDashboardFooter",        { fg = c.overlay0, italic = true })

-- toggleterm
hl("ToggleTerm1FloatBorder",       { fg = c.red_dk,   bg = c.surface0 })
hl("ToggleTermNormal",             { fg = c.text,     bg = c.surface0 })

-- coc.nvim
hl("CocFloating",                  { link = "NormalFloat" })
hl("CocMenuSel",                   { fg = c.bg,       bg = c.red,    bold = true })
hl("CocSearch",                    { fg = c.red_br,   bold = true })
hl("CocErrorSign",                 { fg = c.red_br })
hl("CocWarningSign",               { fg = c.orange })
hl("CocInfoSign",                  { fg = c.subtext1 })
hl("CocHintSign",                  { fg = c.overlay2 })
hl("CocErrorHighlight",            { sp = c.red_br,   undercurl = true })
hl("CocWarningHighlight",          { sp = c.orange,   undercurl = true })
hl("CocHighlightText",             { bg = c.surface1 })
hl("CocCodeLens",                  { fg = c.overlay0, italic = true })
