local M = {}

local defaults = {
  neotree = false,
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  -- Default highlight group links
  local links = {
    ["@keyword.openspec"] = "@keyword",
    ["@type.openspec"] = "@type",
    ["@function.openspec"] = "@function",
    ["@conditional.openspec"] = "@conditional",
    ["@property.openspec"] = "@property",
    ["@operator.openspec"] = "@operator",
    ["@label.openspec"] = "@label",
    ["@string.openspec"] = "@string",
  }

  for group, link in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = link, default = true })
  end

  -- Register openspec_spec parser language for the openspec-spec filetype
  vim.treesitter.language.register("openspec_spec", "openspec-spec")

  -- Register with nvim-treesitter for :TSInstall support (if available)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok and parsers.get_parser_configs then
    local parser_config = parsers.get_parser_configs()
    parser_config.openspec_spec = {
      install_info = {
        url = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h") .. "/tree-sitter-openspec-spec",
        files = { "src/parser.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = "openspec-spec",
    }
  end

  -- Neo-tree integration
  if opts.neotree then
    local neotree_ok, neotree = pcall(require, "openspec.neotree")
    if neotree_ok then
      neotree.setup()
    end
  end
end

return M
