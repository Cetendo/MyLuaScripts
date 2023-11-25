util.keep_running()
util.require_natives(1681379138)

local show_friend = false
local show_crew = false

-- Define a mapping from language names to language codes
local languageCodes = {
    [0] = "Has joined the session.", -- English
    [1] = "A rejoint la session.", -- French
    [2] = "hat das Spiel betreten.", -- German
    [3] = "Ha unito la sessione.", -- Italian
    [4] = "Se ha unido a la sesión.", -- Spanish
    [5] = "Entrou na sessão.", -- Brazilian (Portuguese)
    [6] = "Dołączył do sesji.", -- Polish
    [7] = "Присоединился к сессии.", -- Russian
    [8] = "세션이 참여했습니다.", -- Korean
    [9] = "已加入会话。", -- Chinese (Simplified)
    [10] = "セッションに参加しました。", -- Japanese
    [11] = "Se ha unido a la sesión.", -- Mexican (Spanish)
    [12] = "已加入會議。", -- Chinese (Traditional)
    [13] = "セッションに参加しました。" -- Japanese
}

local function is(pid, playerList)
    if #playerList ~= 0 then
        for _, id in ipairs(playerList) do
            if id == pid then
                return true
            end
        end
        return false
    end
    return false
end
-- Function to display the join message in the detected language
local function displayJoinMessage(pid)
    local player_name = players.get_name(pid)
    local gameLanguage = players.get_language(players.user())
    local localizedJoinText = languageCodes[gameLanguage] or "Has joined the session." -- Default to English if not found
    
    local friendL = players.list_only(false, true, false, false)
    local crewL = players.list_only(false, false, true, false)
    
    -- Display the localized join message
    HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(2)
    if show_friend and is(pid, friendL) then
        util.BEGIN_TEXT_COMMAND_THEFEED_POST('~g~<C>'..player_name..'</C>~s~ '..localizedJoinText)
    elseif show_crew and is(pid, crewL) then 
        util.BEGIN_TEXT_COMMAND_THEFEED_POST('~o~<C>'..player_name..'</C>~s~ '..localizedJoinText)
    else
        util.BEGIN_TEXT_COMMAND_THEFEED_POST('<C>'..player_name..'</C> '..localizedJoinText)
    end
    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, true)
end

players.on_join(function(pid) -- join message
    if not util.is_session_transition_active() and util.is_session_started() then
        displayJoinMessage(pid)
    end
end)

menu.my_root():toggle('Mark Friends Green', {}, '', function (on) show_friend = on end, true)
menu.my_root():toggle('Mark Crew Member Orange', {}, '', function (on) show_crew = on end, true)