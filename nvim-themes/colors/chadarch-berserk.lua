-- chadarch-berserk: Dark fantasy inspired by Berserk
-- Palette: near-black parchment bg, blood crimson, hawk gold, moonlit steel
-- Standalone theme — not tied to any dotfiles system theme

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "chadarch-berserk"
vim.o.termguicolors = true

-- ─── Palette ──────────────────────────────────────────────────────────────────
-- Background: warm near-black, like scorched earth or old manuscript
-- Text: parchment/bone white, like the pages of a cursed tome
-- Crimson: blood red for control flow — violence
-- Gold: hawk emblem / Behelit — glory, functions
-- Amber: torchlight — structure, types
-- Steel: moonlit armor — neutral specials
-- Russet: earthen brown — strings, grounded

local c = {
  bg       = "#0d0906",   -- scorched earth black (warm)
  bg_dark  = "#080402",   -- darker void
  bg_0     = "#030201",   -- pure darkness
  surface0 = "#1e1208",   -- dried blood earth
  surface1 = "#2e1b0d",   -- dark charred wood
  surface2 = "#3d2415",   -- mid dark brown
  overlay0 = "#5c3d28",   -- dim brown-grey (comments)
  overlay1 = "#7a5640",   -- muted tan (line numbers)
  overlay2 = "#9e7860",   -- warm tan

  text     = "#e8d8c4",   -- parchment
  subtext0 = "#c9b89a",   -- dim parchment
  subtext1 = "#dccaad",   -- light parchment
  bone     = "#f5ede0",   -- bone white (brightest)

  -- Main accents (Berserk thematic)
  crimson  = "#c0392b",   -- blood red (keywords — violence)
  dk_crim  = "#8b1a1a",   -- dark blood (subtle keyword alt)
  br_crim  = "#e74c3c",   -- bright crimson (builtins, booleans, return)
  gold     = "#c9a227",   -- hawk/Behelit gold (functions — glory)
  amber    = "#c98327",   -- torchlight amber (types, numbers)
  steel    = "#8fa4b8",   -- moonlit steel (specials, preproc)
  russet   = "#9e6535",   -- rusty earth (strings)
  maroon   = "#6b1515",   -- very dark red (subtle)
  eclipse  = "#2a0d0d",   -- Eclipse darkness (selection bg)

  none     = "NONE",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ─── Editor chrome ────────────────────────────────────────────────────────────
hl("Normal",          { fg = c.text,     bg = c.bg })
hl("NormalNC",        { fg = c.text,     bg = c.bg_dark })
hl("NormalFloat",     { fg = c.text,     bg = c.surface0 })
hl("FloatBorder",     { fg = c.dk_crim,  bg = c.surface0 })
hl("FloatTitle",      { fg = c.gold,     bg = c.surface0, bold = true })
hl("SignColumn",      { fg = c.overlay0, bg = c.bg })
hl("LineNr",          { fg = c.overlay1 })
hl("CursorLineNr",    { fg = c.gold,     bold = true })
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
hl("TabLineSel",      { fg = c.gold,     bg = c.surface0, bold = true })

-- ─── Popup menu ───────────────────────────────────────────────────────────────
hl("Pmenu",           { fg = c.text,     bg = c.surface0 })
hl("PmenuSel",        { fg = c.bg,       bg = c.gold,     bold = true })
hl("PmenuSbar",       { bg = c.surface1 })
hl("PmenuThumb",      { bg = c.dk_crim })
hl("PmenuBorder",     { fg = c.surface2, bg = c.surface0 })

-- ─── Search & selection ───────────────────────────────────────────────────────
hl("Search",          { fg = c.bg,       bg = c.gold })
hl("CurSearch",       { fg = c.bg,       bg = c.br_crim,  bold = true })
hl("IncSearch",       { fg = c.bg,       bg = c.br_crim })
hl("Visual",          { bg = c.eclipse })
hl("VisualNOS",       { bg = c.surface1 })
hl("Substitute",      { fg = c.bg,       bg = c.amber })

-- ─── Messages ─────────────────────────────────────────────────────────────────
hl("ModeMsg",         { fg = c.gold,     bold = true })
hl("MsgArea",         { fg = c.subtext0 })
hl("MoreMsg",         { fg = c.gold })
hl("WarningMsg",      { fg = c.amber })
hl("ErrorMsg",        { fg = c.br_crim,  bold = true })
hl("Question",        { fg = c.steel })

-- ─── Diff ─────────────────────────────────────────────────────────────────────
hl("DiffAdd",         { fg = c.gold,     bg = "#1e1600" })
hl("DiffChange",      { fg = c.amber,    bg = "#1c1000" })
hl("DiffDelete",      { fg = c.crimson,  bg = "#1a0808" })
hl("DiffText",        { fg = c.amber,    bg = "#2a1800", bold = true })

-- ─── Misc ─────────────────────────────────────────────────────────────────────
hl("NonText",         { fg = c.overlay2 })
hl("SpecialKey",      { fg = c.overlay0 })
hl("Whitespace",      { fg = c.surface2 })
hl("Directory",       { fg = c.gold,     bold = true })
hl("Title",           { fg = c.gold,     bold = true })
hl("MatchParen",      { fg = c.br_crim,  bg = c.surface1, bold = true })
hl("SpellBad",        { sp = c.crimson,  undercurl = true })
hl("SpellCap",        { sp = c.amber,    undercurl = true })
hl("SpellLocal",      { sp = c.maroon,   undercurl = true })
hl("SpellRare",       { sp = c.steel,    undercurl = true })
hl("EndOfBuffer",     { fg = c.bg })
hl("Conceal",         { fg = c.overlay0 })

-- ─── Syntax (legacy) ──────────────────────────────────────────────────────────
hl("Comment",         { fg = c.overlay0, italic = true })
hl("Constant",        { fg = c.gold })
hl("String",          { fg = c.russet })
hl("Character",       { fg = c.russet })
hl("Number",          { fg = c.amber })
hl("Boolean",         { fg = c.br_crim,  bold = true })
hl("Float",           { fg = c.amber })
hl("Identifier",      { fg = c.text })
hl("Function",        { fg = c.gold,     bold = true })
hl("Statement",       { fg = c.crimson })
hl("Conditional",     { fg = c.crimson })
hl("Repeat",          { fg = c.crimson })
hl("Label",           { fg = c.steel })
hl("Operator",        { fg = c.subtext0 })
hl("Keyword",         { fg = c.crimson,  bold = true })
hl("Exception",       { fg = c.br_crim,  bold = true })
hl("PreProc",         { fg = c.steel })
hl("Include",         { fg = c.steel })
hl("Define",          { fg = c.steel })
hl("Macro",           { fg = c.amber })
hl("PreCondit",       { fg = c.steel })
hl("Type",            { fg = c.amber })
hl("StorageClass",    { fg = c.crimson })
hl("Structure",       { fg = c.amber })
hl("Typedef",         { fg = c.amber })
hl("Special",         { fg = c.steel })
hl("SpecialChar",     { fg = c.amber })
hl("Tag",             { fg = c.gold })
hl("Delimiter",       { fg = c.subtext0 })
hl("SpecialComment",  { fg = c.overlay2, italic = true })
hl("Debug",           { fg = c.br_crim })
hl("Underlined",      { underline = true })
hl("Ignore",          { fg = c.overlay0 })
hl("Error",           { fg = c.br_crim,  bold = true, underline = true })
hl("Todo",            { fg = c.bg,       bg = c.gold, bold = true })

-- ─── Treesitter ───────────────────────────────────────────────────────────────
hl("@variable",              { fg = c.text })
hl("@variable.builtin",      { fg = c.br_crim,  italic = true })
hl("@variable.parameter",    { fg = c.subtext1 })
hl("@variable.member",       { fg = c.subtext0 })

hl("@constant",              { fg = c.gold })
hl("@constant.builtin",      { fg = c.gold,     bold = true })
hl("@constant.macro",        { fg = c.amber })

hl("@module",                { fg = c.amber,    bold = true })
hl("@label",                 { fg = c.steel })

hl("@string",                { fg = c.russet })
hl("@string.escape",         { fg = c.amber })
hl("@string.special",        { fg = c.amber })
hl("@string.regex",          { fg = c.amber })

hl("@character",             { fg = c.russet })
hl("@number",                { fg = c.amber })
hl("@float",                 { fg = c.amber })
hl("@boolean",               { fg = c.br_crim,  bold = true })

hl("@function",              { fg = c.gold,     bold = true })
hl("@function.builtin",      { fg = c.gold,     italic = true })
hl("@function.call",         { fg = c.gold })
hl("@function.macro",        { fg = c.amber })
hl("@function.method",       { fg = c.gold,     bold = true })
hl("@function.method.call",  { fg = c.gold })

hl("@constructor",           { fg = c.amber })
hl("@operator",              { fg = c.subtext0 })

hl("@keyword",               { fg = c.crimson,  bold = true })
hl("@keyword.function",      { fg = c.crimson,  bold = true })
hl("@keyword.operator",      { fg = c.subtext0 })
hl("@keyword.return",        { fg = c.br_crim,  bold = true })
hl("@keyword.import",        { fg = c.steel })
hl("@keyword.conditional",   { fg = c.crimson })
hl("@keyword.repeat",        { fg = c.crimson })
hl("@keyword.exception",     { fg = c.br_crim,  bold = true })

hl("@type",                  { fg = c.amber })
hl("@type.builtin",          { fg = c.amber,    italic = true })
hl("@type.definition",       { fg = c.amber })

hl("@attribute",             { fg = c.steel })
hl("@property",              { fg = c.subtext0 })

hl("@punctuation",           { fg = c.subtext0 })
hl("@punctuation.bracket",   { fg = c.subtext0 })
hl("@punctuation.delimiter", { fg = c.subtext0 })
hl("@punctuation.special",   { fg = c.amber })

hl("@comment",               { fg = c.overlay0, italic = true })
hl("@comment.todo",          { fg = c.bg,       bg = c.gold,    bold = true })
hl("@comment.note",          { fg = c.bg,       bg = c.steel,   bold = true })
hl("@comment.warning",       { fg = c.bg,       bg = c.amber,   bold = true })
hl("@comment.error",         { fg = c.bg,       bg = c.br_crim, bold = true })

hl("@tag",                   { fg = c.gold })
hl("@tag.attribute",         { fg = c.amber })
hl("@tag.delimiter",         { fg = c.subtext0 })

hl("@markup.heading",        { fg = c.gold,     bold = true })
hl("@markup.link",           { fg = c.steel,    underline = true })
hl("@markup.link.url",       { fg = c.russet,   underline = true })
hl("@markup.raw",            { fg = c.amber })
hl("@markup.italic",         { fg = c.subtext1, italic = true })
hl("@markup.strong",         { fg = c.bone,     bold = true })
hl("@markup.list",           { fg = c.crimson })

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
hl("DiagnosticError",              { fg = c.br_crim })
hl("DiagnosticWarn",               { fg = c.amber })
hl("DiagnosticInfo",               { fg = c.steel })
hl("DiagnosticHint",               { fg = c.overlay2 })
hl("DiagnosticOk",                 { fg = c.gold })
hl("DiagnosticUnderlineError",     { sp = c.br_crim,  undercurl = true })
hl("DiagnosticUnderlineWarn",      { sp = c.amber,    undercurl = true })
hl("DiagnosticUnderlineInfo",      { sp = c.steel,    undercurl = true })
hl("DiagnosticUnderlineHint",      { sp = c.overlay2, undercurl = true })
hl("DiagnosticVirtualTextError",   { fg = c.dk_crim,  italic = true })
hl("DiagnosticVirtualTextWarn",    { fg = c.maroon,   italic = true })
hl("DiagnosticVirtualTextInfo",    { fg = c.overlay1, italic = true })
hl("DiagnosticVirtualTextHint",    { fg = c.overlay0, italic = true })
hl("LspReferenceText",             { bg = c.surface1 })
hl("LspReferenceRead",             { bg = c.surface1 })
hl("LspReferenceWrite",            { bg = c.surface2 })
hl("LspSignatureActiveParameter",  { fg = c.gold,     bold = true })
hl("LspInfoBorder",                { fg = c.surface2 })

-- ─── Plugins ──────────────────────────────────────────────────────────────────

-- gitsigns
hl("GitSignsAdd",                  { fg = c.gold })
hl("GitSignsChange",               { fg = c.amber })
hl("GitSignsDelete",               { fg = c.crimson })

-- nvim-tree
hl("NvimTreeNormal",               { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeNormalNC",             { fg = c.text,     bg = c.bg_dark })
hl("NvimTreeRootFolder",           { fg = c.gold,     bold = true })
hl("NvimTreeFolderName",           { fg = c.subtext1 })
hl("NvimTreeOpenedFolderName",     { fg = c.gold,     bold = true })
hl("NvimTreeFolderIcon",           { fg = c.amber })
hl("NvimTreeFileIcon",             { fg = c.overlay1 })
hl("NvimTreeExecFile",             { fg = c.br_crim,  bold = true })
hl("NvimTreeGitNew",               { fg = c.gold })
hl("NvimTreeGitDirty",             { fg = c.amber })
hl("NvimTreeGitDeleted",           { fg = c.crimson })
hl("NvimTreeSpecialFile",          { fg = c.steel })
hl("NvimTreeIndentMarker",         { fg = c.surface2 })
hl("NvimTreeWinSeparator",         { fg = c.surface2, bg = c.bg_dark })
hl("NvimTreeCursorLine",           { bg = c.surface0 })
hl("NvimTreeSymlink",              { fg = c.steel })
hl("NvimTreeImageFile",            { fg = c.amber })

-- Telescope
hl("TelescopeNormal",              { fg = c.text,     bg = c.surface0 })
hl("TelescopeBorder",              { fg = c.dk_crim,  bg = c.surface0 })
hl("TelescopePromptNormal",        { fg = c.text,     bg = c.surface1 })
hl("TelescopePromptBorder",        { fg = c.crimson,  bg = c.surface1 })
hl("TelescopePromptTitle",         { fg = c.bg,       bg = c.crimson,  bold = true })
hl("TelescopePreviewTitle",        { fg = c.bg,       bg = c.gold,     bold = true })
hl("TelescopeResultsTitle",        { fg = c.dk_crim,  bg = c.surface0 })
hl("TelescopeMatching",            { fg = c.gold,     bold = true })
hl("TelescopeSelection",           { fg = c.bone,     bg = c.eclipse })
hl("TelescopePromptPrefix",        { fg = c.crimson })
hl("TelescopeMultiSelection",      { fg = c.amber })

-- bufferline
hl("BufferLineFill",               { bg = c.bg_dark })
hl("BufferLineBackground",         { fg = c.overlay1, bg = c.surface1 })
hl("BufferLineSelected",           { fg = c.bone,     bg = c.bg,       bold = true })
hl("BufferLineSelectedIndicator",  { fg = c.gold,     bg = c.bg })
hl("BufferLineModified",           { fg = c.amber,    bg = c.surface1 })
hl("BufferLineModifiedSelected",   { fg = c.amber,    bg = c.bg })
hl("BufferLineSeparator",          { fg = c.bg_dark,  bg = c.surface1 })

-- which-key
hl("WhichKey",                     { fg = c.gold })
hl("WhichKeyDesc",                 { fg = c.subtext1 })
hl("WhichKeyGroup",                { fg = c.crimson,  bold = true })
hl("WhichKeySeparator",            { fg = c.overlay0 })
hl("WhichKeyBorder",               { fg = c.surface2 })
hl("WhichKeyNormal",               { bg = c.surface0 })

-- indent-blankline / mini.indentscope
hl("IblIndent",                    { fg = c.surface1 })
hl("IblScope",                     { fg = c.dk_crim })
hl("MiniIndentscopeSymbol",        { fg = c.dk_crim })

-- Snacks (dashboard)
hl("SnacksDashboardHeader",        { fg = c.crimson,  bold = true })
hl("SnacksDashboardKey",           { fg = c.gold })
hl("SnacksDashboardDesc",          { fg = c.subtext0 })
hl("SnacksDashboardIcon",          { fg = c.amber })
hl("SnacksDashboardTitle",         { fg = c.gold,     bold = true })
hl("SnacksDashboardFooter",        { fg = c.overlay0, italic = true })

-- toggleterm
hl("ToggleTerm1FloatBorder",       { fg = c.dk_crim,  bg = c.surface0 })
hl("ToggleTermNormal",             { fg = c.text,     bg = c.surface0 })

-- coc.nvim
hl("CocFloating",                  { link = "NormalFloat" })
hl("CocMenuSel",                   { fg = c.bg,       bg = c.gold,     bold = true })
hl("CocSearch",                    { fg = c.gold,     bold = true })
hl("CocErrorSign",                 { fg = c.br_crim })
hl("CocWarningSign",               { fg = c.amber })
hl("CocInfoSign",                  { fg = c.steel })
hl("CocHintSign",                  { fg = c.overlay2 })
hl("CocErrorHighlight",            { sp = c.br_crim,  undercurl = true })
hl("CocWarningHighlight",          { sp = c.amber,    undercurl = true })
hl("CocHighlightText",             { bg = c.surface1 })
hl("CocCodeLens",                  { fg = c.overlay0, italic = true })
