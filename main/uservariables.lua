----------------------------
--[[ Defining Variables ]]--
----------------------------

-- home variables if needed
-- local home = os.getenv("HOME")

-- Defining variables
local _M = {}
  -- terminal used for keybindings
_M.terminal = "kitty"

  -- terminal based editor
_M.editor = os.getenv("EDITOR") or "nano"

  -- command for running editor
_M.editor_cmd = _M.terminal .. " -e " .. _M.editor

  -- Default modkey (Mod1: Alt; Mod2: Num_Lock; Mod3: ISO_Level5_Shift; Mod4: Super; Mod5: ISO_Level3_Shift)
_M.modkey = "Mod4"

return _M

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
