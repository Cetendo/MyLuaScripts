util.keep_running()
kick_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Kick');
love_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Love Letter Kick');
blacklist_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Blacklist Kick');

kick_state = kick_ref:getState();
love_state = love_ref:getState();
blacklist_state = blacklist_ref:getState();
wait = util.yield

function saveState()
    if kick_ref:getState() ~= kick_state or love_ref:getState() ~= love_state or blacklist_ref:getState() ~= blacklist_state then
        util.toast('Saved Normal Kick Reaction State')
        kick_state = kick_ref:getState();
        love_state = love_ref:getState();
        blacklist_state = blacklist_ref:getState();
    end
end

function disableKick()
    util.toast('Disabled Normal Kick Reaction')
    kick_ref:setState('Off');
    love_ref:setState('Off');
    blacklist_ref:setState('Off');
end

function restoreKick()
    util.toast('Enabled Normal Kick Reaction')
    kick_ref:setState(kick_state);
    love_ref:setState(love_state);
    blacklist_ref:setState(blacklist_state);
end

local kickliste = {}
local restore = false;
util.create_tick_handler(function()
    if players.get_host() == players.user() and kick_state ~= 'Off' and love_state ~= 'Off' and blacklist_state ~= 'Off' and restore == false then 
        disableKick()
        restore = true
    elseif not players.get_host() == players.user() and not kick_ref:getState() == kick_state and not love_ref:getState() == love_state and not blacklist_ref:getState() == blacklist_state and restore == true then 
        restoreKick()
        restore = false
    elseif not players.get_host() == players.user() and  restore == false then
        saveState()
    end
    wait(1000)
end)

players.on_flow_event_done(function(p, name, extra)
    local name = lang.get_localised(name)
    local user = players.user()
    local host = players.get_host()
    local scriptHost = players.get_script_host()

    if extra then
        namewithextra = name .. " (" .. extra .. ")"
    end

    if name == "Kick Event"  then
        util.toast('Kick')
        if host == user and not kickliste[p] then
            kicklist[p] = {}
            kicklist[p] = p;
            menu.trigger_commands("sendpm " .. players.get_name(player) .. " Haha, that didn't go as planned, did it? Maybe it's a sign from the GTA Online karma gods. How about you take a break and enjoy the game from another lobby.")
            wait(9000)
            menu.trigger_commands("sendpm " .. players.get_name(player) .. " bye")
            wait(1000)
            menu.trigger_commands("hostkick " .. players.get_name(player))
        elseif not kickliste[p] then
            menu.trigger_commands("kick " .. players.get_name(player))
        end
        if scriptHost == p then
            menu.trigger_commands("givesh "..user)
        end
    end
end)

players.on_leave(function(player, name)
    kickliste[player] = nil -- Remove the player's cooldown data when they leave
end)

util.on_stop(function()
    restoreKick()
end)