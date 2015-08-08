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
    width = 4,
    height = 4,
    number = 8192,
}

--** local functions **--

local function ShowQrcode(tab)
    -- hide all digits
    for i = 1, digit_attr.number do
        textures[i]:SetHidden(true)
    end

    -- check
    if #tab > digit_attr.number then
        d("|ceee6666so_zh: text too long|r")
        return
    end

    -- place white digits
    local row = 0
    local index = 0
    for row = 1, #tab do
        local rowArray = tab[row]
        for col = 1, #rowArray do
            if rowArray[col] > 0 then
                index = index + 1
                textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
                        wnd_attr.hmargin + col * digit_attr.width, wnd_attr.vmargin + row * digit_attr.height)
                textures[index]:SetHidden(false)
            end
        end
    end
end

local function ShowTextQrcode(text)
    local ok, tab = qrencode.qrcode(text)
    if ok then
        ShowQrcode(tab)
    end
end

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ShowTextQrcode(bodyText)
end

function ESOZH.QUEST:Initialize()
    for i = 1, digit_attr.number do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(digit_attr.width, digit_attr.height)
        textures[i]:SetHidden(true)
        textures[i]:SetTexture('eso_zh/texture/white.dds')
    end
end
