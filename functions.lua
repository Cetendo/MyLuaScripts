joaat = util.joaat

function is_developer()
    local developer = {0x9840BAE, 0xBF99D77, 0x88013B1}
    local user = players.get_rockstar_id(players.user())
    for developer as id do
        if user == id then
            return true
        end
    end
    return false
end

function gen_fren_funcs(name, i)-- NETWORK.NETWORK_GET_FRIEND_COUNT()
    local status = ""
    --[[if NETWORK.NETWORK_IS_FRIEND_INDEX_ONLINE(i) then
        status = " [Online]"
    else
        status = " [Offline]"
    end]]
    local friend_player_function = menu.list(friend_lists_ref, name..status, {"friend "..name}, "", function(); end)
    menu.divider(friend_player_function, name)
    menu.action(friend_player_function, "Join", {"jf "..name}, "Join "..name, function()
        menu.trigger_commands("join "..name)
    end)
    menu.action(friend_player_function, "Spectate", {"sf "..name}, "Spectate "..name, function()
        menu.trigger_commands("namespectate "..name)
    end)
    menu.action(friend_player_function, "Invite", {"if "..name}, "Invite "..name, function()
        menu.trigger_commands("invite "..name)
    end)
    menu.action(friend_player_function, "Open profile", {"pf "..name}, "Open SC Profile from "..name, function()
        menu.trigger_commands("nameprofile "..name)
    end)
end
function me_is_host()
    return (players.get_host() == players.user())
end
function me_is_script_host()
    return (players.get_script_host() == players.user())
end
function drawInfoBox(godmode, vehgodmode, invis, vehInvis)
    local info1 = "Godmode: " .. godmode
    local info2 = "Vehicle Godmode: " .. vehgodmode
    local info3 = "Invisibility: " .. invis
    local info4 = "Vehicle Invisibility: " .. vehInvis
    local infoBoxSizeX = 0.02
    local infoBoxSizeY = 0.04 -- Adjust this value to control the height of the info box
    local spacing = 0.001 -- Adjust this value to control the vertical spacing

    -- Calculate the total height required to display all the information inside the info box
    local totalHeight = spacing * 3 -- Three spaces between four lines of text
    local scale = 0.5

    -- Calculate the total height required for each line and accumulate the total height
    local _, line1Height = directx.get_text_size(info1, scale)
    totalHeight = totalHeight + line1Height

    local _, line2Height = directx.get_text_size(info2, scale)
    totalHeight = totalHeight + line2Height

    local _, line3Height = directx.get_text_size(info3, scale)
    totalHeight = totalHeight + line3Height

    local _, line4Height = directx.get_text_size(info4, scale)
    totalHeight = totalHeight + line4Height

    -- Find the widest line among all four lines of text
    local maxWidth = math.max(
        directx.get_text_size(info1, scale),
        directx.get_text_size(info2, scale),
        directx.get_text_size(info3, scale),
        directx.get_text_size(info4, scale)
    )

    -- Calculate the width of the info box based on the widest line of text and add an offset
    local offsetX = 0.005 -- Adjust this value to control the horizontal offset
    local infoBoxWidth = maxWidth + spacing * 2 + offsetX * 2

    -- Calculate the starting X position to center the info box
    local startX = info_x - (infoBoxWidth * 0.5)

    -- Calculate the starting Y position to center the info box
    local startY = info_y - (totalHeight * 0.5)

    -- Draw the colored rectangle around the info box
    local rectX = startX
    local rectY = startY - spacing
    local rectWidth = infoBoxWidth
    local rectHeight = totalHeight + spacing * 2
    local primaryColor = menu.ref_by_path('Stand>Settings>Appearance>Colours>Primary Colour')
    local r = menu.ref_by_rel_path(primaryColor, 'Red'):getState()
    local g = menu.ref_by_rel_path(primaryColor, 'Green'):getState()
    local b = menu.ref_by_rel_path(primaryColor, 'Blue'):getState()
    local a = menu.ref_by_rel_path(primaryColor, 'Opacity'):getState()
    local border = 0.001
    directx.draw_rect(rectX-border, rectY-border, rectWidth+border*2, rectHeight+border*2, r, g, b, a)
    directx.draw_rect(rectX, rectY, rectWidth, rectHeight, 0, 0, 0, 255)
  
    -- Draw the information inside the info box
    local textAlignment = ALIGN_TOP_LEFT

    directx.draw_text(startX + spacing + offsetX, startY, info1, textAlignment, scale, 255, 0, 255, 255)
    startY = startY + line1Height + spacing

    directx.draw_text(startX + spacing + offsetX, startY, info2, textAlignment, scale, 255, 0, 255, 255)
    startY = startY + line2Height + spacing

    directx.draw_text(startX + spacing + offsetX, startY, info3, textAlignment, scale, 255, 0, 255, 255)
    startY = startY + line3Height + spacing

    directx.draw_text(startX + spacing + offsetX, startY, info4, textAlignment, scale, 255, 0, 255, 255)

    
    
end

function playerNameIsBarCode(name)
    -- Check if the name consists only of 'l' and 'i' characters and has at least 3 of each
    if string.match(name, "^[li]*$") and string.match(name, "l.*l.*l") and string.match(name, "i.*i.*i") then
        return true
    else
        return false
    end
end

function DOES_VEHICLE_HAVE_STEALTH_MODE(vehicle_model)
    switch vehicle_model do
        case joaat("akula"):
        case joaat("annihilator2"):
        --case joaat("avenger"): --
        case joaat("raiju"):
        case joaat("alkonost"):
        --case joaat("kosatka"): --
        case joaat("mircolight"):
        return true
    end
    return false
end
function DOES_VEHICLE_HAVE_IMANI_TECH(vehicle_model)
    switch vehicle_model do
        case joaat("deity"):
        case joaat("granger2"):
        case joaat("buffalo4"):
        case joaat("jubilee"):
        case joaat("patriot3"):
        case joaat("champion"):
        case joaat("greenwood"):
        case joaat("omnisegt"):
        case joaat("virtue"):
        case joaat("r300"):
        case joaat("stingertt"):
        case joaat("buffalo5"):
        case joaat("coureur"):
        case joaat("monstrociti"):
        return true
    end
    return false
end
