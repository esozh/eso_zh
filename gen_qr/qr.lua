-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH.QR = {}

local textures = {}

local WND_ATTR = {
    hmargin = 15,
    top = 50,
    bottom = 15,
}

local DIGIT_ATTR = {
    width = 4,
    number = 8192,
}

local QR_ATTR = {
    ec_level = 4,
    max_str_len = 500,
}

local TEXT_DATA = {
    title = '',
    paragraphs = {},
    paragraphIndex = 0,
}

--** local functions **--

local function ShowQrcode(tab)
    local num_col = #tab

    -- set background
    for col = 1, num_col do
        tab[col][0] = -1
        tab[col][num_col+1] = -1
    end
    tab[0] = {}
    tab[num_col+1] = {}
    for row = 0, num_col+1 do
        tab[0][row] = -1
        tab[num_col+1][row] = -1
    end

    -- place white digits
    local index = 0
    for col = 0, num_col+1 do
        local colArray = tab[col]
        for row = 0, #colArray do
            if colArray[row] < 0 then
                index = index + 1
                textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
                        WND_ATTR.hmargin + col * DIGIT_ATTR.width, WND_ATTR.top + row * DIGIT_ATTR.width)
                textures[index]:SetHidden(false)
            end
        end
    end

    -- resize window
    local qr_width = (num_col + 2) * DIGIT_ATTR.width
    ESOZH.zhWnd:SetDimensions(qr_width + WND_ATTR.hmargin * 2, qr_width + WND_ATTR.top + WND_ATTR.bottom)

    -- show buttons
    ESOZH.buttonPrev:SetHidden(false)
    ESOZH.buttonNext:SetHidden(false)
end

-- show qr code of text in table paragraphs
local function ShowShortTextQrcode()
    -- hide all digits
    ESOZH.QR:HideQrcode()

    local text = TEXT_DATA.paragraphs[TEXT_DATA.paragraphIndex]
    if TEXT_DATA.title ~= nil then
        text = '<title>'..TEXT_DATA.title..'</title>'..'\n\n'..text
    end
    if text ~= nil then
        local ok, tab = qrencode.qrcode(text, QR_ATTR.ec_level)
        if ok then
            ShowQrcode(tab)
        end
    end
end

-- show or hide buttons (next and prev)
local function UpdateButtons()
    ESOZH.buttonPrev:SetHidden(TEXT_DATA.paragraphIndex <= 0)
    ESOZH.buttonNext:SetHidden(TEXT_DATA.paragraphIndex >= #TEXT_DATA.paragraphs)
end

--** public functions **--

function ESOZH.QR:HideQrcode()
    for i = 1, DIGIT_ATTR.number do
        textures[i]:SetHidden(true)
    end
end

function ESOZH.QR:ShowTextQrcode(text, title)
    TEXT_DATA.title = title
    if (#text <= QR_ATTR.max_str_len) then
        TEXT_DATA.paragraphs = { [0] = text }
    else
        TEXT_DATA.paragraphs = {}
        local sentences = split(text, '\n\n')
        local paragraph = ''
        for key, sentence in pairs(sentences) do
            if #(paragraph..'\n\n'..sentence) <= QR_ATTR.max_str_len then
                paragraph = paragraph..'\n\n'..sentence
            elseif paragraph == '' then
                TEXT_DATA.paragraphs[TEXT_DATA.paragraphIndex] = '\n\nsentence too long!'
                break
            else
                TEXT_DATA.paragraphs[TEXT_DATA.paragraphIndex] = paragraph
                TEXT_DATA.paragraphIndex = TEXT_DATA.paragraphIndex + 1
                paragraph = sentence
            end
        end
        if paragraph ~= '' then -- last piece
            TEXT_DATA.paragraphs[TEXT_DATA.paragraphIndex] = paragraph
        end
    end
    TEXT_DATA.paragraphIndex = 0
    ShowShortTextQrcode()
    UpdateButtons()
end

function ESOZH.QR:Initialize()
    -- texture
    for i = 1, DIGIT_ATTR.number do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(DIGIT_ATTR.width, DIGIT_ATTR.width)
        textures[i]:SetHidden(true)
        textures[i]:SetTexture('eso_zh/texture/white.dds')
    end
    -- button
    ESOZH.buttonPrev:SetAnchor(TOPLEFT, ESOZH.zhWnd, BOTTOMLEFT, 15)
    ESOZH.buttonNext:SetAnchor(TOPRIGHT, ESOZH.zhWnd, BOTTOMRIGHT, -15)
    ESOZH.buttonPrev:SetHidden(true)
    ESOZH.buttonNext:SetHidden(true)
end

function ESOZH.QR:OnClickNextButton()
    if TEXT_DATA.paragraphIndex < #TEXT_DATA.paragraphs then
        TEXT_DATA.paragraphIndex = TEXT_DATA.paragraphIndex + 1
        ShowShortTextQrcode()
        UpdateButtons()
    end
end

function ESOZH.QR:OnClickPrevButton()
    if TEXT_DATA.paragraphIndex > 0 then
        TEXT_DATA.paragraphIndex = TEXT_DATA.paragraphIndex - 1
        ShowShortTextQrcode()
        UpdateButtons()
    end
end
