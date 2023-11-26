util.keep_running()
my_root = menu.my_root()

function containsOnlyLI(str)
    local foundL, foundI = false, false

    for i = 1, #str do
        local char = str:sub(i, i)
        if char == 'l' then
            foundL = true
        elseif char == 'I' then
            foundI = true
        else
            return false -- return false immediately if a non-'l'/'I' character is found
        end
    end

    return foundL and foundI -- both 'l' and 'I' must be found for the function to return true
end
menu.divider(my_root, "Running in the Background")

players.add_command_hook(function(pID, player_root)
    local player_name = players.get_name(pID)
    if containsOnlyLI(player_name) then 
        util.toast("Detected "..player_name.." as BarCode and has been blocked from joining your session, attempting smart-kick")
        menu.trigger_commands("historynote"..player_name.." BarCode;historyblock"..player_name.." On;kick"..player_name) 
    end
end)