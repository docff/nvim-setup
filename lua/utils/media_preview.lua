local M = {}

local function is_media(path)
  return path:match("%.png$")
    or path:match("%.jpg$")
    or path:match("%.jpeg$")
    or path:match("%.gif$")
    or path:match("%.webp$")
end

function M.preview(path)
  if not path or not is_media(path) then
    return
  end

  require("telescope").extensions.media.media({
    search_dirs = { vim.fn.fnamemodify(path, ":h") },
    default_text = vim.fn.fnamemodify(path, ":t"),
  })
end

return M
