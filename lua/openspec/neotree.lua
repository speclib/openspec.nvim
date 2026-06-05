local M = {}

local function is_archive_folder(node)
  return node.type == "directory"
    and node.name == "archive"
    and node:get_parent_id()
    and node:get_parent_id():match("/openspec/changes$")
end

function M.icon(config, node, state)
  local cc = require("neo-tree.sources.common.components")
  local result = cc.icon(config, node, state)
  if is_archive_folder(node) then
    result.text = "󰀼 "
    result.highlight = "NeoTreeArchiveIcon"
  end
  return result
end

function M.name(config, node, state)
  local cc = require("neo-tree.sources.common.components")
  local result = cc.name(config, node, state)
  if is_archive_folder(node) then
    result.highlight = "NeoTreeArchiveFolder"
  end
  return result
end

function M.setup()
  vim.api.nvim_set_hl(0, "NeoTreeArchiveIcon", { fg = "#d79921" })
  vim.api.nvim_set_hl(0, "NeoTreeArchiveFolder", { fg = "#a89984", italic = true })

  -- Apply component overrides to neo-tree by MERGING into the existing config.
  -- neo-tree's setup() merges each call onto defaults (not onto the user's
  -- prior config), so passing a bare partial table here would reset everything
  -- else (e.g. default_component_configs.git_status.symbols) back to neo-tree
  -- defaults. Deep-merging the host's current config preserves it.
  local existing = require("neo-tree").config or {}
  require("neo-tree").setup(vim.tbl_deep_extend("force", existing, {
    filesystem = {
      components = {
        icon = M.icon,
        name = M.name,
      },
    },
  }))
end

return M
