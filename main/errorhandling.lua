-----------------------------
-- Handling Awesome Errors --
-----------------------------

-- Imports
local naughty = require("naughty") -- notification library

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
