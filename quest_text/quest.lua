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

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
    ESOZH.QUEST:TranslateAndShowText(bodyText)
end

function ESOZH.QUEST:TranslateAndShowText(text)
    local hash = getHash(text)
    local ids = ESOZH.QUEST.hashTbl[tonumber(hash)]
    d(hash)
    thehash = hash
    d(ids)
    if ids == nil then
        return
    end
    if #ids > 1 then
        for id in ids do
            if text == ESOZH.QUEST.enTbl[id] then
                local texts = ESOZH.QUEST.zhTbl[id]
                ESOZH.QUEST:ShowText(texts)
                break
            end
        end
    else
        local texts = ESOZH.QUEST.zhTbl[ids[0]]
        ESOZH.QUEST:ShowText(texts)
    end
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
    d(textTbl)
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
