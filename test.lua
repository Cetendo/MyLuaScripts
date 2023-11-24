util.keep_running()
util.require_natives(1681379138)
shadow = menu.shadow_root()
my_root = menu.my_root()


function scan_friends()
    local friendCount = NETWORK.NETWORK_GET_FRIEND_COUNT()

    player_history = menu.ref_by_path("Online>Player History")
    for i = 0, friendCount - 1 do
        
        local friendName = NETWORK.NETWORK_GET_FRIEND_NAME(i)
        if not NETWORK.NETWORK_IS_FRIEND_IN_MULTIPLAYER(friendName) then continue end
        cmd_ref = menu.ref_by_rel_path(player_history, friendName)
        menu.focus(cmd_ref)
        util.toast(friendName.." "..lang.get_localised(cmd_ref:getPhysical().menu_name))
        util.yield(2)
    end
    menu.focus(menu.ref_by_rel_path(my_root, "Stop Script"))
end


local previous_friend_count = 0
local previous_friend_names = {}

util.create_tick_handler(function()
    local friendCount = NETWORK.NETWORK_GET_FRIEND_COUNT()
    local current_friend_names = {}

    for i = 0, friendCount - 1 do
        local friendName = NETWORK.NETWORK_GET_FRIEND_NAME(i)
        table.insert(current_friend_names, friendName)
    end

    -- Check if friendCount has changed
    if friendCount ~= previous_friend_count then
        --util.toast("The number of friends has changed.")
        scan_friends()
        -- Update previous state
        previous_friend_count = friendCount
        previous_friend_names = current_friend_names
        return
    end

    -- Check if the order of friend names has changed
    for i, name in ipairs(current_friend_names) do
        if previous_friend_names[i] ~= name then
            --util.toast("The order of friends has changed.")
            scan_friends()
            previous_friend_names = current_friend_names
            break
        end
    end
end)