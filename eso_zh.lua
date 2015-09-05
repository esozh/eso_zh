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
    ESOZH.buttonPrev = ButtonPrev
    ESOZH.buttonNext = ButtonNext

    ESOZH.QR:Initialize()

    -- close button
    ESOZH.close = WINDOW_MANAGER:CreateControlFromVirtual(nil, ESOZH.zhWnd, "ZO_CloseButton")
    ESOZH.close:SetHandler("OnClicked", function(...) ESOZH:HideUi() end)

    -- other events
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_PLAYER_ACTIVATED, ESOZH.LoadScreen)
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_SHOW_BOOK, ESOZH.OnShowBook)
    EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_HIDE_BOOK, ESOZH.OnHideBook)
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
    ESOZH:HideUi()
end

-- when read books
function ESOZH.OnShowBook(eventCode, title, body, medium, showTitle)
    ESOZH.QR:ShowTextQrcode(body, title)
    ESOZH.zhWnd:SetHidden(false)
end

function ESOZH.OnHideBook(eventCode)
    ESOZH:HideUi()
end

function ESOZH:HideUi()
    ESOZH.buttonPrev:SetHidden(true)
    ESOZH.buttonNext:SetHidden(true)
    ESOZH.zhWnd:SetHidden(true)
end


EVENT_MANAGER:RegisterForEvent(ESOZH.name, EVENT_ADD_ON_LOADED, ESOZH.OnAddOnLoaded)
