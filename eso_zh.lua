-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH = {}

ESOZH.name = "eso_zh"

local firstLoad = true


local Origin_InteractWindow_SetText= ZO_InteractWindowTargetAreaBodyText.SetText
local Origin_InteractionManager_OnEndInteraction = ZO_InteractionManager.OnEndInteraction

function ESOZH.OnAddOnLoaded(event, addonName)
    if addonName ~= ESOZH.name then
        return
    end

    qrencode = LibStub:GetLibrary("qrencode")
    LIBMW = LibStub:GetLibrary("LibMsgWin-1.0")
    ESOZH.zhWnd = LIBMW:CreateMsgWindow("eso_zh", "Chinese Translation")
    ESOZH.zhWnd:SetHidden(true)

    ESOZH.QR:Initialize()

    -- other events
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_PLAYER_ACTIVATED, ESOZH.LoadScreen)
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_SHOW_BOOK, ESOZH.OnShowBook)
end

function ESOZH.LoadScreen(event)
    if firstLoad then
        d("|ceeeeeeESOZH by bssthu|r")
        firstLoad = false
    end
end

-- when talk with npc
ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ESOZH.QR:ShowTextQrcode(bodyText)
    ESOZH.zhWnd:SetHidden(false)
end

ZO_InteractionManager.OnEndInteraction = function (self, interaction)
    Origin_InteractionManager_OnEndInteraction(self, interaction)
    ESOZH.zhWnd:SetHidden(true)
end

-- when read books
function ESOZH.OnShowBook(eventCode, title, body, medium, showTitle)
    text = body
    if showTitle then
        text = title..'\n\n'..text
    end
    ESOZH.QR:ShowTextQrcode(text)
end


EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_ADD_ON_LOADED, ESOZH.OnAddOnLoaded)
