-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH.QUEST = {}

local Origin_InteractWindow_SetText= ZO_InteractWindowTargetAreaBodyText.SetText

local textures = {}

local wnd_attr = {
    width = 250,
    height = 300,
    hmargin = 15,
    vmargin = 50,
}

local digit_attr = {
    width = 2,
    height = 2,
}

--** local functions **--

local function getHash(str) -- BKDRHash
    local seed = 131
    local hash = 0
    for i = 1, #str do
        local ch = string.byte(str, i)
        hash = hash * seed + tonumber(ch)
        hash = hash % 0x80000000
    end
    return hash
end

local function ShowQrcode(tab)
    -- hide all digits
    for i = 1, 2048 do
        textures[i]:SetHidden(true)
    end
    -- place white digits
    local row = 0
    local col = 0
    --for i = 1, #tab do
    --    textures[i]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
    --        wnd_attr.hmargin + col * digit_attr.width, wnd_attr.vmargin + row * digit_attr.height)
    --    textures[i]:SetHidden(false)
    --end
    textures[1]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
        wnd_attr.hmargin + col * digit_attr.width, wnd_attr.vmargin + row * digit_attr.height)
    textures[1]:SetHidden(false)
end

local function ShowTextQrcode(text)
    local hash = getHash(text)
    tab = qrencode.qrcode(text)
    ShowQrcode(tab)
end

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ShowTextQrcode(bodyText)
end

function ESOZH.QUEST:Initialize()
    for i = 1, 2048 do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(digit_attr.width, digit_attr.height)
        textures[i]:SetHidden(true)
        textures[i]:SetTexture('eso_zh/texture/white.dds')
    end
end
