util.keep_running()
util.require_natives(1681379138)
local my_root = menu.my_root()

local rateLimits = {}
local rateLimitsPerEvent = {
    ["Crash Event"] = {limit = 3, interval = 60},  -- Example: 3 times every 60 seconds
    ["Freeze"] = {limit = 2, interval = 60}, 
    -- Add more events as needed
}

players.on_flow_event_done(function(p, name, extra)
    name = lang.get_localised(name)
    local name_extra = ''
    if extra then
        name_extra = name
        name_extra ..= " ("
        name_extra ..= extra
        name_extra ..= ")"
    end
    -- Check if the event is subject to rate limiting
    if rateLimitsPerEvent[name] then
        -- Check if the player has a rate limit defined for this event
        local limitData = rateLimits[p] and rateLimits[p][name]

        if not limitData then
            -- If there's no rate limit data for this player and event, initialize it
            rateLimits[p] = {}
            rateLimits[p][name] = {count = 1, lastTime = os.time()}
        else
            local currentTime = os.time()
            local timeElapsed = currentTime - limitData.lastTime

            if timeElapsed < rateLimitsPerEvent[name].interval then
                -- If the time elapsed is within the defined interval, check the rate limit
                if limitData.count >= rateLimitsPerEvent[name].limit then
                    -- Player has exceeded the rate limit, take appropriate action
                    util.toast('Rate limit exceeded for '..name..' by '..players.get_name(p))
                    if name == "Crash Event" then
                        notify('kick')--menu.trigger_commands('kick'..players.get_name(p))
                    end
                    return
                else
                    -- Increment the event count for this player
                    limitData.count = limitData.count + 1
                end
            else
                -- Reset the count and update the last time for a new interval
                limitData.count = 1
                limitData.lastTime = currentTime
            end
        end
    else

        -- Handle the event as needed
        if name == "Spoofed Host Token" and p ~= players.user() then
            if players.get_host() == p then
                menu.trigger_commands("sendpm"..players.get_name(p).." Pls dont kick me! I dont gone kick to get host.")
                util.toast('Warned: '..players.get_name(p))
            end
        elseif name == "Explosion Blaming" then
            menu.trigger_commands('historynote'..players.get_name(p)..' Blocked; historyblock'..players.get_name(p).." on")
            if players.get_host() == players.user() then
                menu.trigger_commands("ban"..players.get_name(p))
                notify('Bannned '..players.get_name(p))
            else
                menu.trigger_commands("kick"..players.get_name(p))
                notify('Kicked '..players.get_name(p))
            end
        end
    end
end)