vim.filetype.add({
  pattern = {
    [".*openspec/.*/spec%.md"] = "openspec-spec",
    [".*openspec/spec%.md"] = "openspec-spec",
    [".*openspec/.*/proposal%.md"] = "openspec-proposal",
    [".*openspec/proposal%.md"] = "openspec-proposal",
    [".*openspec/.*/design%.md"] = "openspec-design",
    [".*openspec/design%.md"] = "openspec-design",
    [".*openspec/.*/tasks%.md"] = "openspec-tasks",
    [".*openspec/tasks%.md"] = "openspec-tasks",
  },
})
