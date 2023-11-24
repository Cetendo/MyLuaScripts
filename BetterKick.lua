util.keep_running()
util.require_natives(1681379138)
kick_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Kick');
love_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Love Letter Kick');
blacklist_ref = menu.ref_by_path('Online>Protections>Events>Kick Event>Blacklist Kick');

kick_state = kick_ref:getState();
love_state = love_ref:getState();
blacklist_state = blacklist_ref:getState();
local kicklist = {} -- Used to track if a player has already been kicked
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

function starts_with(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

local kickliste = {}
local restore = false;
util.create_tick_handler(function()    
    if players.get_host() == players.user() and kick_state ~= 'Off' and love_state ~= 'Off' and blacklist_state ~= 'Off' and restore == false then 
        disableKick()
        restore = true
        --[[HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(255,0,255,255)
	    util.BEGIN_TEXT_COMMAND_THEFEED_POST("You are now Host :)")
	    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT("DIA_ZOMBIE1", "DIA_ZOMBIE1", true, 4, "My Script", "~c~" .. util.get_label_text("PM_PANE_FEE") .. "~s~")
	    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, false)]]
    elseif not players.get_host() == players.user() and kick_ref:getState() ~= kick_state and love_ref:getState() ~= love_state and blacklist_ref:getState() ~= blacklist_state and restore == true then 
        restoreKick()
        restore = false
    elseif players.get_host() ~= players.user() and restore == false then
        saveState()
    end
    wait(10)
end)

players.on_flow_event_done(function(p, name, extra)
    local name = lang.get_localised(name)
    local user = players.user()
    local host = players.get_host()
    local scriptHost = players.get_script_host()
    
    if starts_with(name, "Kick Event") then
        if host == user and not kicklist[p] then
            kicklist[p] = true; -- Mark the player as kicked
            menu.trigger_commands("sendpm " .. players.get_name(p) .. " Haha, that didn't go as planned, did it? Maybe it's a sign from the GTA Online karma gods. How about you take a break and enjoy the game from another lobby.")
            wait(9000)
            menu.trigger_commands("sendpm " .. players.get_name(p) .. " bye bye")
            wait(1000)
            menu.trigger_commands("hostkick ".. players.get_name(p))
        elseif not kicklist[p] then
            kicklist[p] = true; -- Mark the player as kicked
            menu.trigger_commands("kick " .. players.get_name(p))
        end
        if scriptHost == p then
            menu.trigger_commands("givesh "..players.get_name(user))
        end
    end
end)

players.on_leave(function(player, name)
    kicklist[player] = nil -- Reset the kick status when they leave
end)

util.on_stop(function()
    restoreKick()
end)