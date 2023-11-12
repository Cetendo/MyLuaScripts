util.keep_running()
shadow = menu.shadow_root()

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
            if my_org_boss ~= players.user() then
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