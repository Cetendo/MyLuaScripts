util.keep_running()
util.require_natives(1681379138)

local join_text = 'hat das Spiel betreten.'
local show_friend = false

players.on_join(function(pid) -- join message
    local player_name = players.get_name(pid)
    -- Join message
    if not util.is_session_transition_active() and util.is_session_started() then
        HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(2)
        if show_friend then
            local isFriend = false
            local friendList = players.list_only(false, true, false, false)
            if #friendList ~= 0 then
                for listIndex, playerIndex in pairs(friendList) do
                    if playerIndex == pid then
                        isFriend = true
                        break
                    end
                end
            end
            if isFriend then
                util.BEGIN_TEXT_COMMAND_THEFEED_POST('~g~<C>'..player_name..'</C>~s~ '..join_text)
            elseif players.user() ~= pid then
                util.BEGIN_TEXT_COMMAND_THEFEED_POST('<C>'..player_name..'</C> '..join_text)
            end
        else
            util.BEGIN_TEXT_COMMAND_THEFEED_POST('<C>'..player_name..'</C> '..join_text)
        end
        HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, true)        
    end
end)

menu.my_root():toggle('Friend', {}, '', function (on) show_friend = on end, false)