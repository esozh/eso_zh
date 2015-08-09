-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH = {}

ESOZH.name = "eso_zh"


function ESOZH.OnAddOnLoaded(event, addonName)
    if addonName ~= ESOZH.name then
        return
    end

    qrencode = LibStub:GetLibrary("qrencode")
    LIBMW = LibStub:GetLibrary("LibMsgWin-1.0")
    ESOZH.zhWnd = LIBMW:CreateMsgWindow("eso_zh", "Chinese Translation")
    ESOZH.zhWnd:SetHidden(true)

    ESOZH.QUEST:Initialize()

    -- other events
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_PLAYER_ACTIVATED, ESOZH.LoadScreen)
end

function ESOZH.LoadScreen(event)
    d("|ceeeeeeESOZH by bssthu|r")
end


EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_ADD_ON_LOADED, ESOZH.OnAddOnLoaded)
