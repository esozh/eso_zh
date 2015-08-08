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

local function ShowTextQrcode(text)
    local hash = getHash(text)
    -- TODO
end

function ShowQrcode(tab)
    -- hide all digits
    for i = 1, 2048 do
        textures[i]:SetHidden(true)
    end
    -- place white digits
    --row = 0
    --col = 0
    --for i = 1, #tab do
    --    textures[i]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
    --        wnd_attr.hmargin - char_attr.hmargin + col * (char_attr.width + char_attr.hmargin),
    --        wnd_attr.vmargin - char_attr.vmargin + row * (char_attr.height + char_attr.vmargin))
    --    textures[i]:SetHidden(false)
    --end
end

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ShowTextQrcode(bodyText)
end

function ESOZH.QUEST:Initialize()
    for i = 1, 2048 do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(1, 1)
        textures[i]:SetHidden(true)
        textures[i]:SetTexture('eso_zh/texture/white.dds')
    end
end
