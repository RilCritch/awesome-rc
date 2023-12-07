-------------------------------
--[[ Tags (aka Workspaces) ]]--
-------------------------------

-- Imports
local awful = require("awful")
local beautiful = require("beautiful")

-- Metatable
local _M = {}

function _M.get ()
    -- table to return
    local tags = {}

    -- Info for tags
    local taginfo = {}

    -- 1: 󰟒 󱁍   󰻺 󰴕  󱗜 ; 2: 󰛿    󰎞 󱞁 ;
    -- 5: 󰈹 ; 6:   ;
    -- 9:   ;
    taginfo.names = {
        "󰴕", "󱓧", "",
        "󱩼", "", "󰂮",
        "", "󱇣", "󰔍",
    }
    taginfo.icons = {
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil,
    }
    taginfo.layout = {
        RC.layouts[1], RC.layouts[1], RC.layouts[1],
        RC.layouts[1], RC.layouts[1], RC.layouts[1],
        RC.layouts[1], RC.layouts[1], RC.layouts[1],
    }
    taginfo.layouts = {
        RC.layouts, RC.layouts, RC.layouts,
        RC.layouts, RC.layouts, RC.layouts,
        RC.layouts, RC.layouts, RC.layouts,
    }
    taginfo.master_width_factor = {
        0.39, 0.39, 0.39,
        0.39, 0.39, 0.39,
        0.39, 0.39, 0.39,
    }
    taginfo.master_fill_policy = {
        0.2, 0.2, 0.2,
        0.2, 0.2, 0.2,
        0.2, 0.2, 0.2,
    }
    taginfo.master_count = {
        1, 1, 1,
        1, 1, 1,
        1, 1, 1,
    }
    taginfo.column_count = {
        1, 1, 1,
        1, 1, 1,
        1, 1, 1,
    }
    taginfo.gap_single_client = {
        true, true, true,
        true, true, true,
        true, true, true,
    }
    taginfo.selected = {
        true,  false, false,
        false, false, false,
        false, false, false,
    }

    -- creating tags
    awful.screen.connect_for_each_screen(function(s)
        for i, name in ipairs(taginfo.names) do
            awful.tag.add(name, {
                icon                = taginfo.icons[i],
                layout              = taginfo.layout[i],
                layouts             = taginfo.layouts[i],
                master_width_factor = taginfo.master_width_factor[i],
                master_fill_policy  = taginfo.master_fill_policy[i],
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
