util.keep_running()
util.require_natives(1681379138)
shadow = menu.shadow_root()
my_root = menu.my_root()
wait = util.yield

local previous_friend_count = 0
local previous_friend_names = {}
local show_status = true
local last_focus_friend = nil
local focus_back_to = nil
local friends_ref

--------------------------------------------------------
function starts_with(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end
local function getPathToCmd(cmdRef) -- Thx to aaronlink127 on disord for the function
    if not menu.is_ref_valid(cmdRef) then return "Not valid" end
    local tbllen = 0
    local tbl = {}
    repeat
        tbl[++tbllen] = lang.get_string(menu.get_menu_name(cmdRef))
        cmdRef = cmdRef:getParent()
    until not cmdRef:isValid()
    -- Reverse table by swapping first and last, second and second last, 
    for i=1, tbllen//2 do
        tbl[i], tbl[tbllen - i + 1] = tbl[tbllen - i + 1], tbl[i]
    end
    -- Remove the first element (menu version) from the table
    table.remove(tbl, 1)
    return table.concat(tbl, ">")
end

function fucus_to()
    fucus_path = getPathToCmd(menu.get_current_menu_list():getFocus())
    online_friends = getPathToCmd(menu.ref_by_rel_path(online_ref,"Friends ("..NETWORK.NETWORK_GET_FRIEND_COUNT()..")"))
    if starts_with(fucus_path, online_friends) then
        return fucus_path--getPathToCmd(menu.get_current_menu_list():getFocus())
    end
end

--[[function get_status(ref, name)
    local player_history = menu.ref_by_path("Online>Player History")
    local player_ref = menu.ref_by_rel_path(player_history, name)
    local old_online_ref = last_path_in_online_tab  -- Make sure this is set before calling this function
    if player_ref ~= nil and menu.is_ref_valid(player_ref) then
        --util.toast(lang.get_localised(player_ref:getPhysical().menu_name))
        menu.focus(player_ref)

        wait(1000)

        if old_online_ref ~= nil and menu.is_ref_valid(old_online_ref) then
            menu.focus(old_online_ref)
        end 

        if old_online_ref ~= nil and menu.is_ref_valid(old_online_ref) then
            menu.focus(old_online_ref)
        end
        wait(1000)
        -- Fallback if the original reference is no longer valid
        menu.focus(ref)
        
        --wait(5000)
        --util.toast(lang.get_localised(player_ref:getPhysical().menu_name))
    end
end
]]


function get_status(ref, name)
    focus_back_to = ref
    local player_history = menu.ref_by_path("Online>Player History")
    local player_ref = menu.ref_by_rel_path(player_history, name)

    if player_ref ~= nil and menu.is_ref_valid(player_ref) then
        menu.focus(player_ref)
        wait(2)
        menu.focus(ref)
        --util.toast(lang.get_localised(player_ref:getPhysical().menu_name))
        
    end
    focus_back_to = nil
    wait(2000)
    if player_ref ~= nil and menu.is_ref_valid(player_ref) then
        ref.menu_name = lang.get_localised(player_ref:getPhysical().menu_name)
    end
end


function gen_fren_funcs(name, i, friend_lists_ref, replace_ref)
   
    local status = " "-- ..(NETWORK.NETWORK_IS_FRIEND_INDEX_ONLINE(i) ? "[idk]" : "[Offline i guess]")
    local friend_player_function
    if replace_ref == nil then
        friend_player_function = menu.list(friend_lists_ref, name..status, {"friend "..name}, "", function(); end)
    else
        friend_player_function = menu.replace(replace_ref, menu.list(shadow, name..status, {"friend "..name}, "", function(); end))
    end
    if i == 0 then
        friends_ref = friend_player_function -- Theo wanted this
    end

    menu.on_focus(friend_player_function, function()
        if show_status and last_focus_friend ~= name and focus_back_to == nil then
            --util.toast(last_focus_friend or "error 404 not found")
            get_status(friend_player_function, name)
            --util.toast("error 404 not found: " .."My Name is currently not "..lang.get_localised(friend_player_function:getPhysical().menu_name))
            last_focus_friend = name
        end
    end)

    menu.divider(friend_player_function, name..status)
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

function build_friend_menu()
    online_ref = menu.ref_by_path("Online")
    local restore_to = fucus_to()
    local firstOfflineFriend
    -- TODO get currnet focus and focus it in the end of the function
    if menu.ref_by_rel_path(online_ref,"Friends ("..previous_friend_count..")"):isValid() then
        menu.ref_by_rel_path(online_ref,"Friends ("..previous_friend_count..")" ):delete()
    end  
    
    menu_parameter = "Friends ("..(NETWORK.NETWORK_GET_FRIEND_COUNT() ~= 250 ? NETWORK.NETWORK_GET_FRIEND_COUNT() : "Full")..")", {""}, "",function() util.log("on_click") end,function() util.log("on_back") end,function() util.log("on_active_list_update") end
    new_session_ref = menu.ref_by_rel_path(online_ref,"New Session")
    shadow_ref = menu.list(shadow, menu_parameter)
    s_friend_lists_ref = new_session_ref:attachBefore(shadow_ref)
    local friendCount = NETWORK.NETWORK_GET_FRIEND_COUNT()
    
    local offline_to_place = true
    for i = 0, friendCount - 1 do
        local friendName = NETWORK.NETWORK_GET_FRIEND_NAME(i)
        local online = NETWORK.NETWORK_IS_FRIEND_ONLINE(friendName)
        if i == 0 then
            menu.divider(s_friend_lists_ref, 'Online')
        elseif (not online and not firstOfflineFriend) or (i == (friendCount-1) and offline_to_place) then -- TODO, fix that
            firstOfflineFriend = friendName
            menu.divider(s_friend_lists_ref, 'Offline')
            offline_to_place = false
        end
        gen_fren_funcs(friendName, i, s_friend_lists_ref)
    end
    
    if restore_to ~= nil then
        menu.focus(menu.ref_by_path(restore_to))
    end
end

function update_friend_menu()
    online_ref = menu.ref_by_path("Online")
    local restore_to = fucus_to()
    s_friend_lists_ref = menu.ref_by_rel_path(online_ref,"Friends ("..NETWORK.NETWORK_GET_FRIEND_COUNT()..")")
    local f_index = 0
    local firstOfflineFriend
    local s_children = s_friend_lists_ref:getChildren()
    for index = 1, #s_children do
        local s_commandRef = s_children[index]
       
        local friendName = NETWORK.NETWORK_GET_FRIEND_NAME(f_index)
        local online = NETWORK.NETWORK_IS_FRIEND_ONLINE(friendName)
        if index == 1 then
            menu.replace(s_commandRef, menu.divider(shadow, 'Online'))
        elseif not online and not firstOfflineFriend then
            firstOfflineFriend = friendName
            menu.replace(s_commandRef, menu.divider(shadow, 'Offline'))
        elseif (f_index < NETWORK.NETWORK_GET_FRIEND_COUNT()) then
            gen_fren_funcs(friendName, f_index, s_friend_lists_ref, s_commandRef)
            f_index += 1
        else
            menu.replace(s_commandRef, menu.divider(shadow, 'Offline'))
        end
    end
    if restore_to ~= nil then
        menu.focus(menu.ref_by_path(restore_to))
    end
end
--------------------------------------------------------

menu.action(my_root ,'Build', {''}, '', function(on_click)        -- for testing stuff
    build_friend_menu()
end)
menu.action(my_root ,'Update', {''}, '', function(on_click)
    update_friend_menu()
end)

menu.my_root():toggle('Show player status', {}, 'Turn on the Crazy Flickering', function (on) show_status = on end, true)

util.create_tick_handler(function()
    local friendCount = NETWORK.NETWORK_GET_FRIEND_COUNT()
    local current_friend_names = {}

    for i = 0, friendCount - 1 do
        local friendName = NETWORK.NETWORK_GET_FRIEND_NAME(i)
        table.insert(current_friend_names, friendName)
    end

    -- Check if friendCount has changed
    if friendCount ~= previous_friend_count then
        -- util.toast("The number of friends has changed.")
        build_friend_menu()
        -- Update previous state
        previous_friend_count = friendCount
        previous_friend_names = current_friend_names
        return
    end

    -- Check if the order of friend names has changed
    for i, name in ipairs(current_friend_names) do
        if previous_friend_names[i] ~= name then
            -- util.toast("The order of friends has changed.")
            update_friend_menu()
            previous_friend_names = current_friend_names
            break
        end
    end
end)

local friends_menu = friends_ref

-- Function to focus on the friends menu
function focus_on_friends_menu()
    menu.focus(friends_ref)
end

-- Add a button in your custom menu to go to the friends menu
menu.action(my_root, "Go to Friends Menu", {}, "Go to the friends menu in the Online tab", function()
    focus_on_friends_menu()
end)

build_friend_menu()
