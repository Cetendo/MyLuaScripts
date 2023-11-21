util.keep_running()
shadow = menu.shadow_root()
notify = util.toast
wait = util.yield

players.add_command_hook(function(pid, player_root)
    local player_name = players.get_name(pid)
    if players.user() == pid then
        return
    end

    local playerchat = menu.ref_by_rel_path(player_root, 'Chat')
    playerchat:action('Send SMS', {'sms '}, 'Send a SMS', function(on_click)
        menu.show_command_box("sms"..string.lower(player_name).." ")
    end, function(message)
        util.toast('Send \"'..message..'\" to '..player_name)
        players.send_sms(pid, message)
    end,'')

    local joinceo_ref = menu.ref_by_rel_path(player_root, 'Join CEO/MC')
    local inviteceo = menu.action(shadow ,'Invite to CEO/MC', {'ceoinvite '}, '', function(on_click)
        local me = players.user()
        local my_org_type = players.get_org_type(me)
        local my_org_boss = players.get_boss(me)
        local their_org_type = players.get_org_type(pid)
        local their_org_boss = players.get_boss(pid)
        --notify('My Org: '..my_org_type..' My Boss: '..my_org_boss)
        --notify('Their Org: '..their_org_type..' Their Boss: '..their_org_boss)
        if my_org_boss == their_org_boss and my_org_boss ~= -1 then
            return util.toast('I am already with him in a org')
        end
        
        if their_org_type == 1 then -- Cant Invite MC President :/
            return notify('Cant Invite MC President :(') --todo notify me or the player
        end
        
        local playerList = players.list(true, true, true)
        if #playerList == 0 then return util.toast('why') end 

        if my_org_boss ~= me and my_org_boss ~= -1 then
            return util.toast('I already have a boss :/')
        elseif my_org_type == -1 and my_org_boss == -1 then -- if no org
            local org_count = 0
            for listIndex, pid in pairs(playerList) do
                if players.get_boss(pid) == pid and pid ~= -1 then
                    org_count += 1
                end
            end
            
            if org_count < 10 then
                menu.trigger_commands("ceostart") --TODO check for if passive
                wait(1000)
                my_org_type = players.get_org_type(me)
                my_org_boss = players.get_boss(me)
                --notify(my_org_type)
            else
                return notify('No free Slot')
            end
        else
            --todo check size and if not mc change to mc and if full notify
            local org_size = 0
            for listIndex, pid in pairs(playerList) do
                if players.get_boss(pid) == me then
                    org_size += 1
                end
            end
            if my_org_type == 0 and org_size > 3 then
                return notify("Ceo is full") -- Convert to MC ???
            elseif (my_org_type == 1 and org_size > 7) then
                return notify("MC is full")
            end
        end
        notify('Invite here')
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