-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH.QUEST = {}

local Origin_InteractWindow_SetText= ZO_InteractWindowTargetAreaBodyText.SetText

local textures = {}

local char_attr = {
    width = 32,
    height = 32,
    hmargin = 0,
    vmargin = 0,
}

local wnd_attr = {
    width = 250,
    height = 300,
    hmargin = 15,
    vmargin = 50,
}

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ESOZH.QUEST:ShowText({19985, 20040})
end

function ESOZH.QUEST:Initialize()
    for i = 1, 2048 do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(char_attr.width, char_attr.height)
        textures[i]:SetHidden(true)
    end
end

function ESOZH.QUEST:ShowText(textTbl)
    -- hide all chars
    for i = 1, 2048 do
        textures[i]:SetHidden(true)
    end
    -- place chars
    charsInARow = (wnd_attr.width - 2 * wnd_attr.hmargin + char_attr.hmargin) / (char_attr.width + char_attr.hmargin)
    row = 0
    col = 0
    for i = 1, #textTbl do
        d(tostring(textTbl[i]))
        textures[i]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
                wnd_attr.hmargin - char_attr.hmargin + col * (char_attr.width + char_attr.hmargin),
                wnd_attr.vmargin - char_attr.vmargin + row * (char_attr.height + char_attr.vmargin))
        textures[i]:SetTexture('eso_zh/Fonts_dds/'..tostring(textTbl[i])..'.dds')
        textures[i]:SetHidden(false)
        col = col + 1
        if row > charsInARow then
            row = 0
            col = row + 1
        end
    end
end
