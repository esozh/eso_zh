-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH = {}

ESOZH.name = "ESOZH"


function ESOZH.OnAddOnLoaded(event, addonName)
    if addonName ~= ESOZH.name then
        return
    end

    ESOZH.QUEST:Initialize()
end

function ESOZH.LoadScreen(event)
    d("|ceeeeeeESOZH by bssthu|r")
end


EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_ADD_ON_LOADED, ESOZH.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_PLAYER_ACTIVATED, ESOZH.LoadScreen)
