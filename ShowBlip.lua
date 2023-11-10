util.keep_running()
util.require_natives(1681379138)
log = util.toast

my_root = menu.my_root()
shadow = menu.shadow_root()

local vehicleBlipInfo = {
    ["rhino"] = {
        sprite = 421,
        rotate = true
    },
    ["heli"] = {
        sprite = 422,
        rotate = false
    }, -- heli 422
    ["plane"] = {
        sprite = 423,
        rotate = true
    }, -- plane 423
    ["lazer"] = {
        sprite = 424,
        rotate = true
    },
    ["hydra"] = {
        sprite = 424,
        rotate = true
    },
    ["boat"] = {
        sprite = 424,
        rotate = true
    }, -- boat 427
    ["limo2"] = {
        sprite = 460,
        rotate = true
    },
    ["jetski"] = {
        sprite = 471,
        rotate = true
    }, -- jetski 471
    ["insurgent"] = {
        sprite = 426,
        rotate = true
    }, -- pickup
    ["insurgent2"] = {
        sprite = 426,
        rotate = true
    }, -- normal
    ["insurgen3"] = {
        sprite = 426,
        rotate = true
    }, -- custom
    ["blazer5"] = {
        sprite = 512,
        rotate = false
    },
    ["boxville5"] = {
        sprite = 513,
        rotate = false
    },
    ["phantom2"] = {
        sprite = 528,
        rotate = false
    },
    ["idk"] = {
        sprite = 529,
        rotate = false
    }, -- ???
    ["ruiner2"] = {
        sprite = 530,
        rotate = false
    },
    ["dune5"] = {
        sprite = 531,
        rotate = false
    }, -- or dune4 idk
    ["wastelander"] = {
        sprite = 532,
        rotate = false
    },
    ["voltic2"] = {
        sprite = 533,
        rotate = true
    },
    ["technical2"] = {
        sprite = 534,
        rotate = true
    },
    ["apc"] = {
        sprite = 558,
        rotate = true
    },
    ["oppressor"] = {
        sprite = 559,
        rotate = false
    },
    ["halftrack"] = {
        sprite = 560,
        rotate = false
    },
    ["dune3"] = {
        sprite = 561,
        rotate = false
    },
    ["tampa3"] = {
        sprite = 562,
        rotate = true
    },
    ["trailersmall2"] = {
        sprite = 563,
        rotate = false
    },
    -- 564 moc somehow?
    ["alphaz1"] = {
        sprite = 572,
        rotate = true
    },
    ["bombushka"] = {
        sprite = 573,
        rotate = true
    },
    ["havok"] = {
        sprite = 574,
        rotate = false
    },
    ["howard"] = {
        sprite = 575,
        rotate = true
    },
    ["hunter"] = {
        sprite = 576,
        rotate = false
    },
    ["microlight"] = {
        sprite = 577,
        rotate = true
    },
    ["mogul"] = {
        sprite = 578,
        rotate = true
    },
    ["molotok"] = {
        sprite = 579,
        rotate = true
    },
    ["nokota"] = {
        sprite = 580,
        rotate = true
    },
    ["pyro"] = {
        sprite = 581,
        rotate = true
    },
    ["gogue"] = {
        sprite = 582,
        rotate = true
    },
    ["seabreeze"] = {
        sprite = 583,
        rotate = true
    },
    ["starling"] = {
        sprite = 584,
        rotate = true
    },
    ["tula"] = {
        sprite = 585,
        rotate = true
    },
    ["stromberg"] = {
        sprite = 595,
        rotate = false
    },
    ["deluxo"] = {
        sprite = 596,
        rotate = false
    },
    ["thruster"] = {
        sprite = 597,
        rotate = false
    },
    ["khanjali"] = {
        sprite = 598,
        rotate = true
    },
    ["riot2"] = {
        sprite = 599,
        rotate = false
    },
    ["volatol"] = {
        sprite = 600,
        rotate = true
    },
    ["barrage"] = {
        sprite = 601,
        rotate = true
    },
    ["alukla"] = {
        sprite = 602,
        rotate = false
    },
    ["chernobog"] = {
        sprite = 603,
        rotate = false
    },
    ["seasparrow"] = {
        sprite = 612,
        rotate = false
    },
    ["caracara"] = {
        sprite = 613,
        rotate = true
    },
    ["pbus2"] = {
        sprite = 614,
        rotate = false
    },
    ["terrorbyte"] = {
        sprite = 615,
        rotate = false
    },
    ["mernacer"] = {
        sprite = 633,
        rotate = false
    },
    ["scramjet"] = {
        sprite = 634,
        rotate = true
    },
    ["pounder2"] = {
        sprite = 635,
        rotate = false
    },
    ["mule2"] = {
        sprite = 636,
        rotate = false
    },
    ["speedo2"] = {
        sprite = 637,
        rotate = false
    },
    ["blimp3"] = {
        sprite = 638,
        rotate = false
    },
    ["oppressor2"] = {
        sprite = 639,
        rotate = false
    },
    ["strikeforce"] = {
        sprite = 640,
        rotate = true
    },
    ["rcbandito"] = {
        sprite = 646,
        rotate = true
    },
    ["bruiser"] = {
        sprite = 658,
        rotate = false
    },
    ["bruiser2"] = {
        sprite = 658,
        rotate = false
    },
    ["bruiser3"] = {
        sprite = 658,
        rotate = false
    },
    ["brutus"] = {
        sprite = 659,
        rotate = false
    },
    ["brutus2"] = {
        sprite = 659,
        rotate = false
    },
    ["brutus3"] = {
        sprite = 659,
        rotate = false
    },
    ["cerberus"] = {
        sprite = 660,
        rotate = false
    },
    ["cerberus2"] = {
        sprite = 660,
        rotate = false
    },
    ["cerberus3"] = {
        sprite = 660,
        rotate = false
    },
    ["deathbike"] = {
        sprite = 661,
        rotate = false
    },
    ["deathbike2"] = {
        sprite = 661,
        rotate = false
    },
    ["deathbike3"] = {
        sprite = 661,
        rotate = false
    },
    ["dominator4"] = {
        sprite = 662,
        rotate = false
    },
    ["dominator5"] = {
        sprite = 662,
        rotate = false
    },
    ["dominator6"] = {
        sprite = 662,
        rotate = false
    },
    ["impaler2"] = {
        sprite = 664,
        rotate = false
    },
    ["impaler3"] = {
        sprite = 664,
        rotate = false
    },
    ["impaler4"] = {
        sprite = 664,
        rotate = false
    },
    ["imperator"] = {
        sprite = 665,
        rotate = false
    },
    ["imperator2"] = {
        sprite = 665,
        rotate = false
    },
    ["imperator3"] = {
        sprite = 665,
        rotate = false
    },
    ["issi4"] = {
        sprite = 665,
        rotate = false
    },
    ["issi5"] = {
        sprite = 665,
        rotate = false
    },
    ["issi6"] = {
        sprite = 665,
        rotate = false
    },
    ["monster3"] = {
        sprite = 666,
        rotate = false
    },
    ["monster4"] = {
        sprite = 666,
        rotate = false
    },
    ["monster5"] = {
        sprite = 666,
        rotate = false
    },
    ["scarab"] = {
        sprite = 667,
        rotate = false
    },
    ["scarab2"] = {
        sprite = 667,
        rotate = false
    },
    ["scarab3"] = {
        sprite = 667,
        rotate = false
    },
    ["slamvan4"] = {
        sprite = 668,
        rotate = false
    },
    ["slamvan5"] = {
        sprite = 668,
        rotate = false
    },
    ["slamvan6"] = {
        sprite = 668,
        rotate = false
    },
    ["zr380"] = {
        sprite = 669,
        rotate = false
    },
    ["zr3802"] = {
        sprite = 669,
        rotate = false
    },
    ["zr3803"] = {
        sprite = 669,
        rotate = false
    },

    ["raiju"] = {
        sprite = 861,
        rotate = true
    }

    -- Add more mappings here
}

local markedPlayers = {}

local function get_blip_info(player_vehicle, vehicle_hash)
    if player_vehicle ~= 'NULL' then
        if vehicleBlipInfo[player_vehicle] then
            local blipInfo = vehicleBlipInfo[player_vehicle]
            local blipSprite = blipInfo.sprite
            if blipInfo.rotate then
                return blipSprite, true
            else
                return blipSprite, false
            end
        else
            if VEHICLE.IS_THIS_MODEL_A_BOAT(vehicle_hash) then
                return vehicleBlipInfo['boat'], true
            elseif VEHICLE.IS_THIS_MODEL_A_JETSKI(vehicle_hash) then
                return vehicleBlipInfo['jetski'], true
            elseif VEHICLE.IS_THIS_MODEL_A_PLANE(vehicle_hash) then
                return vehicleBlipInfo['plane'], true
            elseif VEHICLE.IS_THIS_MODEL_A_HELI(vehicle_hash) then
                return vehicleBlipInfo['heli'], false
            else
                return 225, false
            end
        end
    else
        return 1, false
    end
end
playerList = players.list(false, true, true)

my_root:toggle_loop('Show all Blip', {''}, '', function()
    local rc_tag = menu.ref_by_path('Players>Settings>Tags>RC Vehicle'):getState();
    local otr_tag = menu.ref_by_path('Players>Settings>Tags>Off The Radar'):getState();
    local dead_tag = menu.ref_by_path('Players>Settings>Tags>Dead'):getState();
    local invisible_tag = menu.ref_by_path('Players>Settings>Tags>Invisible'):getState();
    local modder_tag = menu.ref_by_path('Players>Settings>Tags>Modder'):getState();

    if #playerList ~= 0 then
        for listIndex, pid in pairs(playerList) do
            local pt = players.get_tags_string(pid)
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local player_vehicle = util.reverse_joaat(players.get_vehicle_model(pid))

            -------------- Show --------------
            if not markedPlayers[pid] and ( -- TODO raiju and co
            string.contains(pt, otr_tag) or string.contains(pt, dead_tag) and string.contains(pt, modder_tag)) then
                markedPlayers[pid] = HUD.ADD_BLIP_FOR_ENTITY(playerPed)
                local blip_id, should_rotate = get_blip_info(player_vehicle, players.get_vehicle_model(pid));
                HUD.SET_BLIP_SPRITE(markedPlayers[pid], blip_id)
                HUD.SET_BLIP_COLOUR(markedPlayers[pid], 1)
                HUD.SET_BLIP_ALPHA(markedPlayers[pid], 175)
                HUD.SET_BLIP_NAME_TO_PLAYER_NAME(markedPlayers[pid], pid)
                HUD.SET_BLIP_CATEGORY(markedPlayers[pid], 7)
                if blip_id == 1 then
                    HUD.SHOW_HEADING_INDICATOR_ON_BLIP(markedPlayers[pid], true)
                elseif should_rotate then
                    HUD.SET_BLIP_ROTATION(markedPlayers[pid], ENTITY.GET_ENTITY_HEADING(player_vehicle))
                end
                -------------- Hide --------------

            elseif markedPlayers[pid] and (not string.contains(pt, otr_tag) and not string.contains(pt, dead_tag)) then
                util.remove_blip(markedPlayers[pid])
                markedPlayers[pid] = nil
            elseif markedPlayers[pid] then
                local blip_id, should_rotate = get_blip_info(player_vehicle, players.get_vehicle_model(pid));
                util.log(blip_id.." "..players.get_name(pid))
                HUD.SET_BLIP_SPRITE(markedPlayers[pid], blip_id)
                if blip_id == 1 then
                    HUD.SHOW_HEADING_INDICATOR_ON_BLIP(markedPlayers[pid], true)
                elseif should_rotate then
                    HUD.SET_BLIP_ROTATION(markedPlayers[pid], ENTITY.GET_ENTITY_HEADING(player_vehicle))
                end
            end

        end
    end
end, function()
    if #playerList ~= 0 then
        for i, pid in pairs(playerList) do
            if markedPlayers[pid] then
                util.remove_blip(markedPlayers[pid])
                markedPlayers[pid] = nil
            end
        end
    end
end)

players.on_leave(function(pid, name)
    if markedPlayers[pid] then
        util.remove_blip(markedPlayers[pid])
        markedPlayers[pid] = nil
    end
end)
