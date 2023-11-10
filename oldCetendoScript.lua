-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end


local auto_update_config = {
    source_url="https://raw.githubusercontent.com/Cetendo/CetendoScript/main/CetendoScript.lua",
    script_relpath=SCRIPT_RELPATH,
    verify_file_begins_with="--",
    dependencies={
        {
            name="function",
            source_url="https://raw.githubusercontent.com/Cetendo/CetendoScript/main/lib/functions.lua",
            script_relpath="lib/Cetendo/functions",
            verify_file_begins_with="local",
            is_required=true,
        }
    }
}
-- Stand only
if not filesystem.stand_dir then
    print("Unsupported. Only stand is supported")
    return
end
------------------------------------------------------------
-- Global Stuff
------------------------------------------------------------
-- https://stand.gg/help/lua-api-documentation
-- https://nativedb.dotindustries.dev/natives/
-- https://docs.fivem.net/docs/game-references/blips/
-- https://wiki.rage.mp/index.php?title=Blips
util.keep_running()
util.require_natives(1681379138)
local functions = require("cetendo.funcs")
local mysubDir = scriptdir.."Cetendo\\"

if not is_developer() then 
    if async_http.have_access() then
        --auto_updater.run_auto_update(auto_update_config)
    else
        notify("This Script needs Internet Access to auto-update!")
    end
end


local my_root = menu.my_root()
local shadow = menu.shadow_root()
log = util.log
notify = util.toast
wait = util.yield
wait_once = util.yield_once

------------------------------------------------------------
-- Variables
------------------------------------------------------------
local info_x = 0.75
local info_y = 0.05
local less_destructive_force_sh = false
local if_host_force_sh = false
local markedPlayers = {}
local vehicleBlipInfo = {
    ["rhino"] = {sprite = 421, rotate = true},
    -- heli 422
    -- plane 423
    ["lazer"] = {sprite = 424, rotate = true},
    ["hydra"] = {sprite = 424, rotate = true},
    -- boat 427
    ["limo2"] = {sprite = 460, rotate = true},
    ["insurgent"] = {sprite = 426, rotate = true}, --pickup
    ["insurgent2"] = {sprite = 426, rotate = true}, --normal
    ["insurgen3"] = {sprite = 426, rotate = true}, --custom
    ["blazer5"] = {sprite = 512, rotate = false},
    ["boxville5"] = {sprite = 513, rotate = false},
    ["phantom2"] = {sprite = 528, rotate = false},
    ["idk"] = {sprite = 529, rotate = false}, --???
    ["ruiner2"] = {sprite = 530, rotate = false},
    ["dune5"] = {sprite = 531, rotate = false}, --or dune4 idk
    ["wastelander"] = {sprite = 532, rotate = false},
    ["voltic2"] = {sprite = 533, rotate = true},
    ["technical2"] = {sprite = 534, rotate = true},
    ["apc"] = {sprite = 558, rotate = true},
    ["oppressor"] = {sprite = 559, rotate = false},
    ["halftrack"] = {sprite = 560, rotate = false},
    ["dune3"] = {sprite = 561, rotate = false},
    ["tampa3"] = {sprite = 562, rotate = true},
    ["trailersmall2"] = {sprite = 563, rotate = false},
    -- 564 moc somehow?
    ["alphaz1"] = {sprite = 572, rotate = true},
    ["bombushka"] = {sprite = 573, rotate = true},
    ["havok"] = {sprite = 574, rotate = false},
    ["howard"] = {sprite = 575, rotate = true},
    ["hunter"] = {sprite = 576, rotate = false},
    ["microlight"] = {sprite = 577, rotate = true},
    ["mogul"] = {sprite = 578, rotate = true},
    ["molotok"] = {sprite = 579, rotate = true},
    ["nokota"] = {sprite = 580, rotate = true},
    ["pyro"] = {sprite = 581, rotate = true},
    ["gogue"] = {sprite = 582, rotate = true},
    ["seabreeze"] = {sprite = 583, rotate = true},
    ["starling"] = {sprite = 584, rotate = true},
    ["tula"] = {sprite = 585, rotate = true},
    ["stromberg"] = {sprite = 595, rotate = false},
    ["deluxo"] = {sprite = 596, rotate = false},
    ["thruster"] = {sprite = 597, rotate = false},
    ["khanjali"] = {sprite = 598, rotate = true},
    ["riot2"] = {sprite = 599, rotate = false},
    ["volatol"] = {sprite = 600, rotate = true},
    ["barrage"] = {sprite = 601, rotate = true},
    ["alukla"] = {sprite = 602, rotate = false},
    ["chernobog"] = {sprite = 603, rotate = false},
    ["seasparrow"] = {sprite = 612, rotate = false},
    ["caracara"] = {sprite = 613, rotate = true},
    ["pbus2"] = {sprite = 614, rotate = false},
    ["terrorbyte"] = {sprite = 615, rotate = false},
    ["mernacer"] = {sprite = 633, rotate = false},
    ["scramjet"] = {sprite = 634, rotate = true},
    ["pounder2"] = {sprite = 635, rotate = false},
    ["mule2"] = {sprite = 636, rotate = false},
    ["speedo2"] = {sprite = 637, rotate = false},
    ["blimp3"] = {sprite = 638, rotate = false},
    ["oppressor2"] = {sprite = 639, rotate = false},
    ["strikeforce"] = {sprite = 640, rotate = true},
    ["rcbandito"] = {sprite = 646, rotate = true},
    ["bruiser"] = {sprite = 658, rotate = false},
    ["bruiser2"] = {sprite = 658, rotate = false},
    ["bruiser3"] = {sprite = 658, rotate = false},
    ["brutus"] = {sprite = 659, rotate = false},
    ["brutus2"] = {sprite = 659, rotate = false},
    ["brutus3"] = {sprite = 659, rotate = false},
    ["cerberus"] = {sprite = 660, rotate = false},
    ["cerberus2"] = {sprite = 660, rotate = false},
    ["cerberus3"] = {sprite = 660, rotate = false},
    ["deathbike"] = {sprite = 661, rotate = false},
    ["deathbike2"] = {sprite = 661, rotate = false},
    ["deathbike3"] = {sprite = 661, rotate = false},
    ["dominator4"] = {sprite = 662, rotate = false},
    ["dominator5"] = {sprite = 662, rotate = false},
    ["dominator6"] = {sprite = 662, rotate = false},
    ["impaler2"] = {sprite = 664, rotate = false},
    ["impaler3"] = {sprite = 664, rotate = false},
    ["impaler4"] = {sprite = 664, rotate = false},
    ["imperator"] = {sprite = 665, rotate = false},
    ["imperator2"] = {sprite = 665, rotate = false},
    ["imperator3"] = {sprite = 665, rotate = false},
    ["issi4"] = {sprite = 665, rotate = false},
    ["issi5"] = {sprite = 665, rotate = false},
    ["issi6"] = {sprite = 665, rotate = false},
    ["monster3"] = {sprite = 666, rotate = false},
    ["monster4"] = {sprite = 666, rotate = false},
    ["monster5"] = {sprite = 666, rotate = false},
    ["scarab"] = {sprite = 667, rotate = false},
    ["scarab2"] = {sprite = 667, rotate = false},
    ["scarab3"] = {sprite = 667, rotate = false},
    ["slamvan4"] = {sprite = 668, rotate = false},
    ["slamvan5"] = {sprite = 668, rotate = false},
    ["slamvan6"] = {sprite = 668, rotate = false},
    ["zr380"] = {sprite = 669, rotate = false},
    ["zr3802"] = {sprite = 669, rotate = false},
    ["zr3803"] = {sprite = 669, rotate = false},
    

    ["raiju"] = {sprite = 861, rotate = true},
    
    -- Add more mappings here
}
------------------------------------------------------------
-- Help Funktions
------------------------------------------------------------
local function me_is_host()
    return (players.get_host() == players.user())
end
local function me_is_script_host()
    return (players.get_script_host() == players.user())
end
local function drawInfoBox(godmode, vehgodmode, invis, vehInvis)
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
    directx.draw_line(rectX, rectY, rectX + rectWidth, rectY, menu.ref_by_rel_path(primaryColor, 'Red'):getState(), menu.ref_by_rel_path(primaryColor, 'Green'):getState(), menu.ref_by_rel_path(primaryColor, 'Blue'):getState(), menu.ref_by_rel_path(primaryColor, 'Opacity'):getState()) -- Top line
    directx.draw_line(rectX, rectY + rectHeight, rectX + rectWidth, rectY + rectHeight, menu.ref_by_rel_path(primaryColor, 'Red'):getState(), menu.ref_by_rel_path(primaryColor, 'Green'):getState(), menu.ref_by_rel_path(primaryColor, 'Blue'):getState(), menu.ref_by_rel_path(primaryColor, 'Opacity'):getState()) -- Bottom line
    directx.draw_line(rectX, rectY, rectX, rectY + rectHeight, menu.ref_by_rel_path(primaryColor, 'Red'):getState(), menu.ref_by_rel_path(primaryColor, 'Green'):getState(), menu.ref_by_rel_path(primaryColor, 'Blue'):getState(), menu.ref_by_rel_path(primaryColor, 'Opacity'):getState()) -- Left line
    directx.draw_line(rectX + rectWidth, rectY, rectX + rectWidth, rectY + rectHeight, menu.ref_by_rel_path(primaryColor, 'Red'):getState(), menu.ref_by_rel_path(primaryColor, 'Green'):getState(), menu.ref_by_rel_path(primaryColor, 'Blue'):getState(), menu.ref_by_rel_path(primaryColor, 'Opacity'):getState()) -- Right line

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

------------------------------------------------------------
-- Script Tabs
------------------------------------------------------------
local my_autos = my_root:list('Automations', {}, 'My Automations')
	local my_force_sh = my_autos:list('Force Script Host', {}, 'TODO')
local my_settings = my_root:list('Settings', {}, 'Settings ...')
	local my_info = my_settings:list('Info', {}, '...')


            my_info:slider_float('Info x position', {}, 'x', 6, 94, info_x*100, 1, function(val)
                info_x = val / 100
            end)
            my_info:slider_float('Info y position', {}, 'y', 4, 96, info_y*100, 1, function(val)
                info_y = val / 100
            end)
--
 
players.on_flow_event_done(function(p, name, extra)
    name = lang.get_localised(name)
    local _name, _extra = ''
        if extra then
            _name = name
            _extra = extra
            name ..= " ("
            name ..= extra
            name ..= ")"
        end
        if name == "Spoofed Host Token (Aggressive)" and p ~= players.user() then
            if players.get_host() == p then
                menu.trigger_commands("sendpm"..players.get_name(p).." Pls dont kick me! I dont gone kick to get host.")
                util.toast('Warned: '..players.get_name(p))
            elseif players.get_host() == players.user() then
                menu.trigger_commands("sendpm"..players.get_name(p).." !!!Dont even try to kick me!!! (You will regret it)")
                util.toast('Warned: '..players.get_name(p))
            end
        elseif name == "Text Message" then
            util.toast('You got a Text')
        elseif _name == "Kick Event" then
            util.toast('Oh no someone is trying to kick you')
        elseif _name == "Crash Event" then
            util.toast('Oh no someone is trying to crash you')
        end
end)

local sh_ref = menu.ref_by_path('Online>Session>Become Script Host')
local grap_sh_ref =menu.action(shadow, "Grab Script Host", {"sh"}, "Grabs Script Host in a less destructive way.", function ()
	trigger_commands("givesh"..players.get_name(players.user()))
end)
sh_ref:attachAfter(grap_sh_ref)
my_force_sh:toggle_loop('Automatically become Script Host', {'autoscripthost'}, 'Get Scripthost automatically', function ()
    if not util.is_session_transition_active() and util.is_session_started() --[[and PLAYER.IS_PLAYER_FREE_AIMING(players.user())]] then
        if (not me_is_script_host() and not me_is_host()) or (not me_is_script_host() and me_is_host() and if_host_force_sh) then --todo
            util.toast("Force Scripthost from "..players.get_name(players.get_script_host()))
		    if less_destructive_force_sh then
			    menu.trigger_commands("sh")			
		    else
                menu.trigger_commands("scripthost")
		    end
        end
    end
	util.yield(1000)
end)
my_force_sh:toggle('Force if Host', {}, 'Also if Host force Script Host', function (on) if_host_force_sh = on end, false)
my_force_sh:toggle('less destructive', {}, 'If Force Script Host is less destructive', function (on) less_destructive_force_sh = on end, true)
my_autos:toggle_loop("Disable Phone", {""}, "Disables the Phone when certain conditions are met.", function()
    local phone = menu.ref_by_path("Game>Disables>Straight To Voicemail")
    if chat.is_open() or PLAYER.IS_PLAYER_FREE_AIMING(players.user()) or util.is_interaction_menu_open() or menu.is_open() then
        if phone.value == false then
            phone.value = true
        end
    elseif phone.value == true then
        phone.value = false
    end
end)
-- idk
menu.toggle_loop(my_root, 'Infobox', {''}, 'Show my Infobox', function ()
    local immortality = menu.get_state(menu.ref_by_path('Self>Immortality'))
    local self_invisibility = menu.get_state(menu.ref_by_path('Self>Appearance>Invisibility'))
    local indestructible = menu.get_state(menu.ref_by_path('Vehicle>Indestructible'))
    local veh_invisibility = menu.get_state(menu.ref_by_path('Vehicle>Invisibility'))
    if immortality == 'On' or indestructible == 'On' or self_invisibility ~= 'Disabled' or veh_invisibility ~= 'Disabled' then
        drawInfoBox(immortality, indestructible, self_invisibility, veh_invisibility)
    end
    if not me_is_host() and not util.is_session_transition_active() then
        util.draw_debug_text('#'..players.get_host_queue_position(players.user()))
    end
    
end)

local function get_blip_sprite(player_vehicle)
    if player_vehicle ~= 'NULL' then
        if vehicleBlipInfo[player_vehicle] then
            local blipInfo = vehicleBlipInfo[player_vehicle]
            local blipSprite = blipInfo.sprite
            --local shouldRotate = blipInfo.rotate
            --HUD.SET_BLIP_ROTATION(blip, players.get_cam_rot(pid))
            return blipSprite
        else
            --VEHICLE.IS_THIS_MODEL_A_BOAT(Hash modle)
            --VEHICLE.IS_THIS_MODEL_A_JETSKI(Hash modle)
            --VEHICLE.IS_THIS_MODEL_A_PLANE(Hash modle)
            --VEHICLE.IS_THIS_MODEL_A_HELI(Hash modle)
            return 225
        end            
    else
        return 1
    end
end
local function find_sprite_color(pid, pb)
    if PED.IS_PED_DEAD_OR_DYING(pd, 1) then
        return 7
    elseif players.is_otr(pid) then
        return 5
    else
        return 2
    end
end
menu.toggle_loop(my_root, 'Reveal Stuff', {''}, '', function ()
    
    local playersList = players.list(false, true, true)
    if #playersList ~= 0 then
        for listIndex, pid in pairs(playersList) do
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pb = HUD.GET_BLIP_FROM_ENTITY(playerPed)
            local player_vehicle = util.reverse_joaat(players.get_vehicle_model(pid))
            local blipSprite = get_blip_sprite(player_vehicle)

            if pb == 0 and not markedPlayers[pid] and not players.is_in_interior(pid) then
                markedPlayers[pid] = HUD.ADD_BLIP_FOR_ENTITY(playerPed)
                HUD.SET_BLIP_SPRITE(markedPlayers[pid], blipSprite)
                HUD.SET_BLIP_COLOUR(markedPlayers[pid], find_sprite_color(pid, pb))
                HUD.SET_BLIP_ALPHA(markedPlayers[pid], 250) --todo setting for this
                HUD.SET_BLIP_NAME_TO_PLAYER_NAME(markedPlayers[pid], pid)
                HUD.SET_BLIP_CATEGORY(markedPlayers[pid], 7)
                HUD.SHOW_HEADING_INDICATOR_ON_BLIP(markedPlayers[pid], true)
                --notify(players.get_name(pid).." got revealed "..player_vehicle.." "..blipSprite)
            elseif pb == 0 then
                --HUD.SET_BLIP_SPRITE(blip, blipSprite)
                --notify(players.get_name(pid))
                --HUD.SET_BLIP_COLOUR(markedPlayers[pid], find_sprite_color(pid, pb))
            elseif (not pb == 0 or players.is_in_interior(pid)) and markedPlayers[pid] then
                util.remove_blip(markedPlayers[pid])
                markedPlayers[pid] = nil
                --notify(players.get_name(pid).."has a blip again")
            end
        end
    end
end, function()
    local playerList = players.list(false, true, true)
    for i, pid in pairs(playerList) do
        if markedPlayers[pid] then
            util.remove_blip(markedPlayers[pid])
            markedPlayers[pid] = nil
        end
    end
end)

--------------------------------------
-- Player options
--------------------------------------
players.add_command_hook(function(pid, player_root)
    local player_name = players.get_name(pid)

    local playerchat = menu.ref_by_rel_path(player_root, 'Chat')
    playerchat:action('Send SMS', {'sms '}, 'Send a SMS', function(on_click)
        if players.user() == pid then
            return util.toast('You cannot send yourself a SMS')
        end
        menu.show_command_box("sms"..string.lower(player_name).." ")
    end, function(message)
        util.toast('Send \"'..message..'\" to '..player_name)
        players.send_sms(pid, message)
    end,'')

    local joinceo_ref = menu.ref_by_rel_path(player_root, 'Join CEO/MC')
    local inviteceo = menu.action(shadow ,'Invite to CEO/MC', {'ceoinvite '}, '', function(on_click)
        if players.user() == pid then
                return util.toast('You cannot invite yourself')
        end
        local my_org_type = players.get_org_type(players.user())
        local my_org_boss = players.get_boss(players.user())
        local their_org_type = players.get_org_type(pid)
        local their_org_boss = players.get_boss(pid)
        notify('My Org: '..my_org_type..' My Boss: '..my_org_boss)
        notify('Their Org: '..their_org_type..' Their Boss: '..their_org_boss)
        if my_org_type == -1 and my_org_boss == -1 then -- if no org
            local org_slots = menu.ref_by_path('Online>CEO/MC>Colour Slots')
            local org_slot_free = false
            for slot = 0, 9 do
                local slotState = menu.ref_by_rel_path(org_slots, slot):getState()
                if slotState == '0' then
                    
                    org_slot_free = true
                    break -- Exit the loop early if "N/A" is found
                end
            end
            if org_slot_free then
                menu.trigger_commands("ceostart")
                wait(1000)
                notify(my_org_type)
            else
                return notify('No free Slot')
            end
        else -- ceo/mc
            if my_org_boss ~= players.user() then -- not org boss todo but does it matter?
                    return util.toast('Bin nicht Boss :/') --todo notify me or the player
            end
            --todo check size and if not mc change to mc and if full notify
        end
                    --mc boss cant inv mc boss (normally)
            --ceo boss cant inv mc boss (normally)
        if their_org_type == 1 and their_org_boss == pid then
            return util.toast('Cant Invite MC President :/') --todo notify me or the player
        end
        util.trigger_script_event(1 << pid, {
            -245642440,
            players.user(),
            4,
            10000, -- wage?
            0, 0, 0, 0,
            memory.read_int(memory.script_global(1924276 + 9)), -- 1924276.f_8
            memory.read_int(memory.script_global(1924276 + 10)), -- 1924276.f_9
        })
    end, nil, nil, COMMANDPERM_FRIENDLY) 
    joinceo_ref:attachAfter(inviteceo)
end)

players.on_join(function(pid) -- join message
    local player_name = players.get_name(pid)
    -- Join message
    if not util.is_session_transition_active() and util.is_session_started() then
        HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(2)
        local isFriend = false
        local friendList = players.list_only(false, true, false, false)
        if #friendList ~= 0 then
            for listIndex, playerIndex in pairs(friendList) do
                if playerIndex == pid then
                    isFriend = true
                    break
                end
            end
        end
        if isFriend then
            util.BEGIN_TEXT_COMMAND_THEFEED_POST('~g~<C>'..player_name..'</C>~s~ hat das Spiel betreten.')
        elseif players.user() ~= pid then
            util.BEGIN_TEXT_COMMAND_THEFEED_POST('<C>'..player_name..'</C> hat das Spiel betreten.')
        end
        HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, true)
    end
end)

-- Manually check for updates with a menu option
menu.action(my_root, "Check for Update", {}, "The script will automatically check for updates at most daily, but you can manually check using this option anytime.", function()
    auto_update_config.check_interval = 0
    util.toast("Checking for updates")
    if auto_updater.run_auto_update(auto_update_config) then
        util.toast("No updates found")
    end    
end)
