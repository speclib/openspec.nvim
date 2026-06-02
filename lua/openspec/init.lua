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
  -- The compiled parser .so comes from tree-sitter-openspec (separate package)
  local ok, _ = pcall(vim.treesitter.language.register, "openspec_spec", "openspec-spec")
  if not ok then
    vim.notify("openspec.nvim: openspec_spec parser not found. Install tree-sitter-openspec.", vim.log.levels.WARN)
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
