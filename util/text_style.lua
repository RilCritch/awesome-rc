-- vim:fileencoding=utf-8:shiftwidth=4:tabstop=4:foldmethod=marker

-- -> Text styling functions for markup and fonts

-- [[ Modules ]] --
local theme = require("beautiful")

local color_util = require("util.color_util")

-- [[ Utilities ]] --
local function check_type(type, variable)
    local var_type = type(variable)
    return type == var_type
end

local function check_from_table(acceptable, variable)
    if not check_type("table", acceptable) then
        return false
    end

    for _, value in pairs(acceptable) do
        if variable == value then
            return true
        end
    end
    return false
end


local text_style = {}


-- [[ Markup Span Syntax ]] --
-- These will return nil if the argument is not compatible with pango

-- Colors
function text_style.get_markup_fg(color)
    local check  = color_util.check_pango_color(color)
    local prefix = "foreground='"

    local text = check and prefix .. color .. "'" or nil
    return text
end

function text_style.get_markup_bg(color)
    local check  = color_util.check_pango_color(color)
    local prefix = "background='"

    local text = check and prefix .. color .. "'" or nil
    return text
end

-- Font
function text_style.get_markup_font(family, size)
    family = family or ""
    size = size or ""
    local text

    local font_family = #family ~= 0 and family or nil
    local font_size = #size ~= 0 and size or nil

    if font_family == nil or font_size == nil or check_type("number", font_size) then
        text = nil
    else
        text = "font='" .. font_family .. " " .. font_size .. "'"
    end

    return text
end

function text_style.get_markup_font_style(style)
    local accept = { "normal", "oblique", "italic" }
    local check = check_from_table(accept, style)

    local text = check and "font_style='" .. style .. "'" or nil
    return text
end

function text_style.get_markup_font_weight(weight)
    local accept = { "ultralight", "light", "normal", "bold", "ultrabold", "heavy" }
    local check  = check_from_table(accept, weight)

    local text
    if check then
        text = "font_weight='" .. weight .. "'"
    elseif check_type("number", weight) then
        text = "font_weight=" .. weight
    else
        text = nil
    end

    return text
end

-- Text Styles
function text_style.get_markup_underline(underline, color)
    local accept = { "none", "single", "double", "low", "error" }
    local check  = check_from_table(accept, underline)
    local underline_text = check and "underline='" .. underline .. "'" or nil

    if underline_text == nil then
        return nil
    end

    local color_text = color_util.check_pango_color(color) and " underline_color='" .. color .. "'" or ""
    local text = underline_text .. color_text
    return text
end

-- [[ Pango Markup Span Builder ]] --
function text_style.build_markup(args)
    -- Check for arguments
    args = args or {}
    local fg = args.fg or nil
    local bg = args.bg or nil
    local font = {
        family = args.font.family or nil,
        size = args.font.family or nil
    }
    local style = args.style or nil
    local weight = args.weight or nil
    local underline = {
        style = args.underline.style or nil,
        color = args.underline.color or nil
    }
    local text = args.text or nil
    local fg_text
    local bg_text
    local font_text
    local style_text
    local weight_text
    local underline_text

    if text == nil then
        return nil
    end

    if fg ~= nil then
        local fg_res = text_style.get_markup_fg(fg)
        fg_text = (fg_res ~= nil) and " " .. fg_res or ""
    end

    if bg ~= nil then
        local bg_res = text_style.get_markup_bg(bg)
        bg_text = (bg_res ~= nil) and " " .. bg_res or ""
    end

    if font.family ~= nil and font.size ~= nil then
        local font_res = text_style.get_markup_font(font.family, font.size)
        font_text = (font_res ~= nil) and " " .. font_res or ""
    end

    if style ~= nil then
        local style_res = text_style.get_markup_font_style(style)
        style_text = (style_res ~= nil) and " " .. style_res or ""
    end

    if weight ~= nil then
        local weight_res = text_style.get_markup_font_weight(weight)
        weight_text = (weight_res ~= nil) and " " .. weight_res or ""
    end

    if underline.style ~= nil then
        local underline_res = text_style.get_markup_underline(underline.style, underline.color)
        underline_text = (underline_res ~= nil) and " " .. underline_res or ""
    end

    local span_prefix = "<span"
    local close_span  = ">"
    local span_suffix = "</span>"

    local start_span = span_prefix .. fg_text .. bg_text .. font_text .. style_text .. weight_text .. underline_text .. close_span
    local markup_text = start_span .. text .. span_suffix

    return markup_text
end

return text_style
