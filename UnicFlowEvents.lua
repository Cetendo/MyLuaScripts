util.keep_running()
util.require_natives(1681379138)

local my_root = menu.my_root()
local loggedEventsList = my_root:list('Logged Unic Events',{''},'')
local loggedNames = {} -- Table to keep track of logged names

players.on_flow_event_done(function(p, name, extra)
    name = lang.get_localised(name)
    if extra then
        name = name .. " (" .. extra .. ")"
    end
    
    if not loggedNames[name] then
        loggedNames[name] = true -- Mark the name as logged
        table.insert(loggedNames, name) -- Add the unique name to the array
        loggedEventsList:readonly(players.get_name(p)..': '..name, '')
        --util.toast(players.get_name(p) .. ": " .. name)
    end
end)