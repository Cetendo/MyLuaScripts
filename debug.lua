util.keep_running()
--------------
--vars
--------------
local scale = 0.6
local y_offset = 0.02
local r, g, b, a = 255, 0, 255, 255
local alignment = ALIGN_TOP_LEFT
local differences  = {
    menu = {
        x = 0,      -- X position for menu elements
        y = 0,
    },
    ui = {
        x = 0,    -- X position for UI elements
        y = 0.3,
    },
}

local function get_type_name(type)
    local type_names = {
        [COMMAND_LINK] = "COMMAND_LINK",
        [COMMAND_ACTION] = "COMMAND_ACTION",
        [COMMAND_ACTION_ITEM] = "COMMAND_ACTION_ITEM",
        [COMMAND_INPUT] = "COMMAND_INPUT",
        [COMMAND_TEXTSLIDER] = "COMMAND_TEXTSLIDER",
        [COMMAND_TEXTSLIDER_STATEFUL] = "COMMAND_TEXTSLIDER_STATEFUL",
        [COMMAND_READONLY_NAME] = "COMMAND_READONLY_NAME",
        [COMMAND_READONLY_VALUE] = "COMMAND_READONLY_VALUE",
        [COMMAND_READONLY_LINK] = "COMMAND_READONLY_LINK",
        [COMMAND_DIVIDER] = "COMMAND_DIVIDER",
        [COMMAND_LIST] = "COMMAND_LIST",
        [COMMAND_LIST_CUSTOM_SPECIAL_MEANING] = "COMMAND_LIST_CUSTOM_SPECIAL_MEANING",
        [COMMAND_LIST_PLAYER] = "COMMAND_LIST_PLAYER",
        [COMMAND_LIST_COLOUR] = "COMMAND_LIST_COLOUR",
        [COMMAND_LIST_HISTORICPLAYER] = "COMMAND_LIST_HISTORICPLAYER",
        [COMMAND_LIST_READONLY] = "COMMAND_LIST_READONLY",
        [COMMAND_LIST_REFRESHABLE] = "COMMAND_LIST_REFRESHABLE",
        [COMMAND_LIST_CONCEALER] = "COMMAND_LIST_CONCEALER",
        [COMMAND_LIST_SEARCH] = "COMMAND_LIST_SEARCH",
        [COMMAND_LIST_NAMESHARE] = "COMMAND_LIST_NAMESHARE",
        [COMMAND_LIST_ACTION] = "COMMAND_LIST_ACTION",
        [COMMAND_LIST_SELECT] = "COMMAND_LIST_SELECT",
        [COMMAND_TOGGLE_NO_CORRELATION] = "COMMAND_TOGGLE_NO_CORRELATION",
        [COMMAND_TOGGLE] = "COMMAND_TOGGLE",
        [COMMAND_TOGGLE_CUSTOM] = "COMMAND_TOGGLE_CUSTOM",
        [COMMAND_SLIDER] = "COMMAND_SLIDER",
        [COMMAND_SLIDER_FLOAT] = "COMMAND_SLIDER_FLOAT",
        [COMMAND_SLIDER_RAINBOW] = "COMMAND_SLIDER_RAINBOW"
    }

    return type_names[type] or "Unknown"
end

function draw_elements(elements)
    for key, element in pairs(elements) do
        local x = differences[key].x
        local y = y_offset
        if not element:isValid() then directx.draw_text(x, differences[key].y, "Nothing to see here.",alignment, scale, r, g, b, a) continue end
        -- Create an empty string to store the formatted key-value pairs
        local concatenatedCommands = ""
        for k, v in pairs(element.command_names) do
            concatenatedCommands = concatenatedCommands .. string.format("%s, ", v)
        end
        -- Remove the trailing comma and space
        concatenatedCommands = "{" .. concatenatedCommands:sub(1, -3) .. "}"

        directx.draw_text(x, differences[key].y       , "---Current-"..key:upper().."-Focus---",                         alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +    y, "Parent: "..lang.get_localised(element:getParent().menu_name),   alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*2, "Path: "..lang.get_localised(element.menu_name),                 alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*3, "Type: "..get_type_name(element:getType()),                      alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*4, "State: "..element:getState(),                                   alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*5, "Value: "..element.value,                                        alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*6, "Command(s): "..concatenatedCommands,                            alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*7, "Help Text: "..lang.get_localised(element.help_text),            alignment, scale, r, g, b, a)
        directx.draw_text(x, differences[key].y +  y*8, "Config Name: "..element.name_for_config,                        alignment, scale, r, g, b, a)
    end
end

util.create_tick_handler(function()
    util.try_run(function() 
        local current_menu = menu.get_current_menu_list():getFocus():getPhysical()
        local current_ui = menu.get_current_ui_list():getFocus():getPhysical()
    
        local elements = {
            menu = current_menu,
            ui = current_ui,
        }
        draw_elements(elements)
    end)
end)