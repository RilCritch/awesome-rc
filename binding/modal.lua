-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker

-- [[ Modules ]] --

local modalawesome = require("modalawesome")

-- [[ Modes ]] --
local modes = {
    -- movement = require("binding.modes.navigation"),
    -- launcher = require("binding.modes.movement"),
    -- layout = require("binding.modes.layout"),
}

modalawesome.init {
    modkey = "Escape",
    default_more = "tag",
    modes = modes,
    stop_name = "clinet",
    keybindings = {},
}
