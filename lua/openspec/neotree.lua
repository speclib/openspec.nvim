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

  -- Apply component overrides to neo-tree
  require("neo-tree").setup({
    filesystem = {
      components = {
        icon = M.icon,
        name = M.name,
      },
    },
  })
end

return M
