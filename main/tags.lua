-------------------------------
--[[ Tags (aka Workspaces) ]]--
-------------------------------

-- == == == == == Typical Tag Usage == == == == == --
--[[ Tag 1 ]]--- Home | Sys settings | Awesome Config ---
     -- 1 Browser (Help with system settings or misc)
     -- 2 Terminals (Config files)
--[[ Tag 2 ]]--- Planning, Tasks, Calendar | Notes ---
     -- 1 Browser (Google Calendar)
     -- 2 Terminals (Tasks | Notes)
--[[ Tag 3 ]]--- Files | Git, Github | Builds ---
     -- 1 Browser (Github)
     -- 1 File Manager (Thunar)
     -- 2 Terminals (Repos | Builds )
--[[ Tag 4 ]]--- Browser | Research | Notes ---
     -- 2 Browsers (Search | ChatGPT)
     -- 1 Terminal (Notes)

--[[ Tag 5 ]]--- Programming, Scripting | Config ---
     -- 1 Browser (Search)
     -- 2 Terminals
--[[ Tag 6 ]]--- Programming, Scripting | Config ---
     -- 1 Browser
     -- 2 Terminals
--[[ Tag 7 ]]--- App, Hardware Settings | Config ---
     -- 1 Browser (Search)
     -- 2 Terminal
--[[ Tag 8 ]]--- App, Hardware Settings | Config ---
     -- 1 Browser (Search)
     -- 2 Terminal
--[[ Tag 9 ]]--- Media Editing | Misc Configs ---
     -- 1 Browser (Search)
     -- 1 Terminal (Config files) or
     -- 1 Media Editor (Inkscape | Photopea)

--[[ Tag 10 ]]--- Music | Streaming | Chatting ---
     -- 1 Spotify
     -- 1 Browser (Youtube)
     -- 1 Discord

-- Imports
local awful = require("awful")
local beautiful = require("beautiful")

-- Metatable
local _M = {}

function _M.get ()
    -- table to return
    local tags = {}

    -- commonly used values
    local width = 0.40
    local fav_lay = RC.layouts[1]
    local sec_lay = RC.layouts[2]

    -- Info for tags
    local taginfo = {}

    taginfo.names = {
        "󰴕", "󰥪", "󰉋",
        "", "󱩼", "󱩽",
        "󰂮", "󰘙", "󱇣",
        "",
    }
    taginfo.icons = {
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil,
        nil,
    }
    taginfo.layout = {
        fav_lay, fav_lay, sec_lay,
        sec_lay, fav_lay, sec_lay,
        fav_lay, sec_lay, sec_lay,
        sec_lay,
    }
    taginfo.layouts = {
        RC.layouts, RC.layouts, RC.layouts,
        RC.layouts, RC.layouts, RC.layouts,
        RC.layouts, RC.layouts, RC.layouts,
        RC.layouts,
    }
    taginfo.master_width_factor = {
        width, width, width,
        width, width, width,
        width, width, 0.54,
        width,
    }
    taginfo.master_count = {
        1, 1, 1,
        1, 1, 1,
        1, 1, 1,
        1,
    }
    taginfo.column_count = {
        2, 2, 2,
        2, 2, 2,
        2, 2, 2,
        2,
    }
    taginfo.gap_single_client = {
        true, true, true,
        true, true, true,
        true, true, true,
        true,
    }
    taginfo.selected = {
        true,  false, false,
        false, false, false,
        false, false, false,
        false,
    }

    -- creating tags
    awful.screen.connect_for_each_screen(function(s)
        for i, name in ipairs(taginfo.names) do
            awful.tag.add(name, {
                icon                = taginfo.icons[i],
                layout              = taginfo.layout[i],
                layouts             = taginfo.layouts[i],
                master_width_factor = taginfo.master_width_factor[i],
                master_fill_policy  = "master_width_factor",
                master_count        = taginfo.master_count[i],
                column_count        = taginfo.column_count[i],
                gap_single_client   = taginfo.gap_single_client[i],
                gap                 = beautiful.useless_gap,
                screen              = s,
                selected            = taginfo.selected[i],
            })
        end

        tags[s] = s.tags
    end)

    return tags
end

return setmetatable({}, {
    __call = function(_,...)
        return _M.get(...) ---@diagnostic disable-line: redundant-parameter
    end
})
-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker
