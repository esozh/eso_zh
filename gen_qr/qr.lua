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

local paragraphs = {}
local paragraphIndex = 0

--** local functions **--

local function ShowQrcode(tab)
    local num_col = #tab

    -- place white digits
    local index = 0
    for col = 1, num_col do
        local colArray = tab[col]
        for row = 1, #colArray do
            if colArray[row] < 0 then
                index = index + 1
                textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
                        WND_ATTR.hmargin + col * DIGIT_ATTR.width, WND_ATTR.top + row * DIGIT_ATTR.width)
                textures[index]:SetHidden(false)
            end
        end
    end

    -- place background
    for i = 0, num_col do
        -- top
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            WND_ATTR.hmargin + i * DIGIT_ATTR.width, WND_ATTR.top)
        textures[index]:SetHidden(false)
        -- right
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            WND_ATTR.hmargin + (num_col + 1) * DIGIT_ATTR.width, WND_ATTR.top + i * DIGIT_ATTR.width)
        textures[index]:SetHidden(false)
        -- bottom
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            WND_ATTR.hmargin + (i + 1) * DIGIT_ATTR.width, WND_ATTR.top + (num_col + 1) * DIGIT_ATTR.width)
        textures[index]:SetHidden(false)
        -- left
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            WND_ATTR.hmargin, WND_ATTR.top + (i + 1) * DIGIT_ATTR.width)
        textures[index]:SetHidden(false)
    end

    -- resize window
    local qr_width = (num_col + 2) * DIGIT_ATTR.width
    ESOZH.zhWnd:SetDimensions(qr_width + WND_ATTR.hmargin * 2, qr_width + WND_ATTR.top + WND_ATTR.bottom)

    -- show buttons
    ButtonPrev:SetHidden(false)
    ButtonNext:SetHidden(false)
end

-- show qr code of text in table paragraphs
local function ShowShortTextQrcode()
    -- hide all digits
    ESOZH.QR:HideQrcode()

    local text = paragraphs[paragraphIndex]
    if text ~= nil then
        local ok, tab = qrencode.qrcode(text, QR_ATTR.ec_level)
        if ok then
            ShowQrcode(tab)
        end
    end
end

-- show or hide buttons (next and prev)
local function UpdateButtons()
    ButtonPrev:SetHidden(paragraphIndex <= 0)
    ButtonNext:SetHidden(paragraphIndex >= #paragraphs)
end

--** public functions **--

function ESOZH.QR:HideQrcode()
    for i = 1, DIGIT_ATTR.number do
        textures[i]:SetHidden(true)
    end
end

function ESOZH.QR:ShowTextQrcode(text)
    if (#text <= QR_ATTR.max_str_len) then
        paragraphs = { [0] = text }
    else
        paragraphs = {}
        local sentences = split(text, '\n\n')
        local paragraph = ''
        for key, sentence in pairs(sentences) do
            if #(paragraph..'\n\n'..sentence) <= QR_ATTR.max_str_len then
                paragraph = paragraph..'\n\n'..sentence
            elseif paragraph == '' then
                paragraphs[paragraphIndex] = '\n\nsentence too long!'
                break
            else
                paragraphs[paragraphIndex] = paragraph
                paragraphIndex = paragraphIndex + 1
                paragraph = sentence
            end
        end
        if paragraph ~= '' then -- last piece
            table.insert(paragraphs, paragraphIndex, paragraph)
        end
    end
    paragraphIndex = 0
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
    ButtonPrev:SetAnchor(TOPLEFT, ESOZH.zhWnd, BOTTOMLEFT, 15)
    ButtonNext:SetAnchor(TOPRIGHT, ESOZH.zhWnd, BOTTOMRIGHT, -15)
    ButtonPrev:SetHidden(true)
    ButtonNext:SetHidden(true)
end

function ESOZH.QR:OnClickNextButton()
    if paragraphIndex < #paragraphs then
        paragraphIndex = paragraphIndex + 1
        ShowShortTextQrcode()
        UpdateButtons()
    end
end

function ESOZH.QR:OnClickPrevButton()
    if paragraphIndex > 0 then
        paragraphIndex = paragraphIndex - 1
        ShowShortTextQrcode()
        UpdateButtons()
    end
end
