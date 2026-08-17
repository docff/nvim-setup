-- banana.nvim: renders HTML-ish markup (.nml) as neovim UIs.
--
-- NOTE: this is NOT a viewer for arbitrary .html files off disk or the web. It
-- renders its own dialect (`.nml` + `.ncss`) into a floating window, and is
-- meant for building plugin UIs. Open a `.nml` file and `:BananaSo` it.
--
-- Requires a native zig library. Two macOS-specific problems mean we cannot use
-- banana's own `require("banana").installLibbanana()` build step:
--   1. It shells out to a bare `zig build`, which also links an executable that
--      fails on the unresolved lua_*/nvim_* symbols.
--   2. On macOS the linker rejects undefined symbols in a shared library by
--      default; those symbols are supplied by the nvim host at runtime, so we
--      must pass `-fallow-shlib-undefined`.
-- So we build the dylib directly instead. Upstream targets zig 0.15.x: 0.16
-- fails to compile (@Type removed, stricter comptime) and 0.14 cannot link its
-- own build runner against the macOS 26 SDK, so we pin to zig@0.15.
local function zig_exe()
  -- Homebrew keg-only zig@0.15 first, since a linked `zig` is likely 0.16.
  for _, candidate in ipairs({
    "/opt/homebrew/opt/zig@0.15/bin/zig",
    "/usr/local/opt/zig@0.15/bin/zig",
  }) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return vim.fn.exepath("zig")
end

-- The two grammars banana needs, in nvim-treesitter `main` spec format.
local GRAMMARS = {
  nml = "https://github.com/CWood-sdf/tree-sitter-nml",
  ncss = "https://github.com/CWood-sdf/tree-sitter-ncss",
}

local function register_grammars()
  local parsers = require("nvim-treesitter.parsers")
  for lang, url in pairs(GRAMMARS) do
    parsers[lang] = { install_info = { url = url, branch = "main" }, tier = 3 }
    vim.treesitter.language.register(lang, lang)
  end
end

-- Install every grammar banana might parse, synchronously. This is the
-- replacement for its `:TSInstallSync`-based installTsParsers(); callers parse
-- immediately afterwards, so it must not return before the parsers exist.
local function install_grammars()
  register_grammars()
  local missing = {}
  for lang in pairs(GRAMMARS) do
    if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) == 0 then
      missing[#missing + 1] = lang
    end
  end
  if #missing > 0 then
    require("nvim-treesitter").install(missing):wait(300000)
  end
end

local function build_libbanana(plugin)
  local zig = zig_exe()
  if zig == "" then
    error("banana.nvim: zig not found. Install it with `brew install zig@0.15`.")
  end

  local version = vim.fn.system({ zig, "version" }):gsub("%s+$", "")
  if not version:match("^0%.15%.") then
    vim.notify(
      ("banana.nvim: building with zig %s, but upstream expects 0.15.x."):format(version),
      vim.log.levels.WARN
    )
  end

  -- Emit straight into lua/banana/ where `require("banana.libbanana_zig")` looks.
  -- The extension must be `.so` even on macOS: nvim's C-module loader only ever
  -- searches `?.so` on the runtimepath, so a `.dylib` is simply never found.
  local out = plugin.dir .. "/lua/banana"
  local result = vim.fn.system({
    zig,
    "build-lib",
    "-OReleaseFast",
    "-Mroot=" .. plugin.dir .. "/zig/src/root.zig",
    "--name",
    "banana_zig",
    "-dynamic",
    "-fallow-shlib-undefined",
    "--cache-dir",
    plugin.dir .. "/zig/.zig-cache",
    "-femit-bin=" .. out .. "/libbanana_zig.so",
  })
  if vim.v.shell_error ~= 0 then
    error("banana.nvim: zig build failed:\n" .. result)
  end
end

return {
  "CWood-sdf/banana.nvim",
  build = build_libbanana,
  -- Deliberately NOT lazy-loaded on `ft = "nml"`: banana's own plugin/ files are
  -- what register the nml/ncss filetypes and define :BananaSo, so gating on the
  -- filetype is circular and nothing would ever load. Upstream notes banana is
  -- already internally lazy, so eager loading here is cheap.
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Must stay false: banana's initTsParsers() calls
    -- `require("nvim-treesitter.parsers").get_parser_configs()`, which only
    -- exists on nvim-treesitter's old `master` branch. This config runs the
    -- rewritten `main` branch, where that function is gone, so setupTs = true
    -- throws on startup. We register the parsers ourselves in init() below.
    setupTs = false,
  },
  init = function()
    -- banana's plugin/filetypes.lua maps the extensions only once the plugin is
    -- loaded; register them here too so detection works on the very first file.
    vim.filetype.add({ extension = { nml = "nml", ncss = "ncss" } })

    -- `nvim-treesitter.install` starts every install/update by calling its
    -- internal reload_parsers(), which nils `package.loaded` for the parsers
    -- module and re-requires it — throwing away any grammar we registered
    -- beforehand. It then fires `User TSUpdate`, which exists precisely so
    -- out-of-tree grammars can re-add themselves. Hooking it is the only way a
    -- custom parser survives to be installed.
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = register_grammars,
    })

    -- Grammars are fetched on demand the first time an nml/ncss buffer opens,
    -- so a fresh install doesn't pay for a compile it may never need.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "nml", "ncss" },
      callback = function()
        -- Install both grammars, not just this buffer's: any .nml with a
        -- <style> block is parsed as ncss too, and a missing ncss parser fails
        -- deep inside banana's parser with a bare nil index.
        install_grammars()
      end,
    })
  end,
  config = function(_, opts)
    local banana = require("banana")

    -- banana's own treesitter bootstrap is hard-wired to nvim-treesitter's
    -- `master` branch: initTsParsers() calls the removed
    -- `parsers.get_parser_configs()`, and installTsParsers() runs the removed
    -- `:TSInstallSync`. Both are called unconditionally from the render path
    -- (nml/parser.lua -> fromFile/fromString), so `setupTs = false` alone only
    -- defers the crash from startup to the first :BananaSo. Swap both for
    -- `main`-branch equivalents before anything can call them.
    banana.initTsParsers = register_grammars
    banana.installTsParsers = install_grammars

    banana.setup(opts)
  end,
}
