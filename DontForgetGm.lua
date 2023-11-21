util.require_natives(1663599433)

local notification_type = 1
local notify_id = 0
local last_text
local game_color = 213
local directx_x = 0.1
local directx_y = 0.1
local directx_color = {1.0, 0.0, 1.0, 1.0}
local game_color_ref, directx_x_pos_ref, directx_y_pos_ref, directx_color_ref
local textAlignment = ALIGN_TOP_LEFT

local function cleanupNotify()
	if notify_id ~= 0 then
		HUD.THEFEED_REMOVE_ITEM(notify_id)
	end
end

local function hideOther(value)
    if value == 1 then
        game_color_ref.visible = true
        directx_x_pos_ref.visible = false
        directx_color_ref.visible = false
    elseif value == 2 then
        game_color_ref.visible = false
        directx_x_pos_ref.visible = true
        directx_color_ref.visible = true
    elseif value == 3 then
        game_color_ref.visible = false
        directx_x_pos_ref.visible = false
        directx_color_ref.visible = false
    end
end


menu.my_root():toggle_loop('Enabled', {''}, '', function()
    local immortality = menu.get_state(menu.ref_by_path('Self>Immortality'))
    local self_invisibility = menu.get_state(menu.ref_by_path('Self>Appearance>Invisibility'))
    local indestructible = menu.get_state(menu.ref_by_path('Vehicle>Indestructible'))
    local veh_invisibility = menu.get_state(menu.ref_by_path('Vehicle>Invisibility'))
    local text = ""

    if not util.is_session_transition_active() and util.is_session_started() then
        if immortality == 'On' then
            text = text.."Godmode: "..immortality
        end
        if self_invisibility ~= 'Disabled' then
            if text ~= "" then text = text .. "\n" end
            text = text.."Own Visibility: "..self_invisibility
        end
        if indestructible == 'On' then
            if text ~= "" then text = text .. "\n" end
            text = text.."Vehicle Godmode: "..indestructible
        end
        if veh_invisibility ~= 'Disabled' then
            if text ~= "" then text = text .. "\n" end
            text = text.."Vehicle Visibility: "..veh_invisibility
        end 
    end
    
    if notification_type == 1 then
        if text == "" then 
            cleanupNotify() 
            last_text = text
            return 
        elseif text ~= last_text then
            cleanupNotify() 
            HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(game_color)
		    HUD.THEFEED_FREEZE_NEXT_POST()
            util.BEGIN_TEXT_COMMAND_THEFEED_POST(text)
	        notify_id = HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, true) 
            last_text = text
        end
    elseif notification_type == 2 then
        if directx_x > 0.5 then
            textAlignment = ALIGN_TOP_RIGHT
        else
            textAlignment = ALIGN_TOP_LEFT
        end
        directx.draw_text(directx_x, 0.1, text, textAlignment, 1, directx_color[1], directx_color[2], directx_color[3], directx_color[4])
        --directx.draw_rect(0.1, 0.1, 0.12, 0.12, 255, 0, 255, 255)
    elseif notification_type == 3 then

    end
end, function()
    cleanupNotify()
    last_text = ""
end)

menu.my_root():list_select("Display", {}, "", {
    [1] = {"Game"},
    [2] = {"DirectX"},
    [3] = {"Stand maybe"},
}, 1, function(value, menu_name, prev_value, click_type)
    util.toast("Value changed to " .. lang.get_localised(menu_name) .. " (" .. value .. ")")
    notification_type = value
    if value == 1 then
        hideOther(value)
    elseif value == 2 then
        hideOther(value)
        cleanupNotify()
        last_text = text
    elseif value == 3 then
        hideOther(value)
        cleanupNotify()
        last_text = text
    end
end)

------------------ Game  ------------------

game_color_ref = menu.my_root():slider("Notification Colour", {""}, "", 0, 1000, game_color, 1, function(val)
    game_color = val
    last_text = ""
end)
----------------- DirectX -----------------
directx_x_pos_ref = menu.my_root():slider_float('X', {}, 'y', 0, 100, directx_x*100, 1, function(val)
    directx_x = val / 100
end)

directx_color_ref = menu.my_root():colour(lang.find_builtin("Colour"), {}, "", 1.0, 0.0, 1.0, 1.0, true, function(colour, click_type)
    --util.toast(colour)
    --directx_color = colour
end)

hideOther(notification_type)
util.on_stop(cleanupNotify)