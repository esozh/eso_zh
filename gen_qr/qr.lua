-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH.QR = {}

local textures = {}

local wnd_attr = {
    hmargin = 15,
    top = 50,
    bottom = 15,
}

local digit_attr = {
    width = 4,
    number = 8192,
}

--** local functions **--

local function ShowQrcode(tab)
    -- hide all digits
    ESOZH.QR:HideQrcode()

    local num_col = #tab

    -- place white digits
    local index = 0
    for col = 1, num_col do
        local colArray = tab[col]
        for row = 1, #colArray do
            if colArray[row] < 0 then
                index = index + 1
                textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
                        wnd_attr.hmargin + col * digit_attr.width, wnd_attr.top + row * digit_attr.width)
                textures[index]:SetHidden(false)
            end
        end
    end

    -- place background
    for i = 0, num_col do
        -- top
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            wnd_attr.hmargin + i * digit_attr.width, wnd_attr.top)
        textures[index]:SetHidden(false)
        -- right
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            wnd_attr.hmargin + (num_col + 1) * digit_attr.width, wnd_attr.top + i * digit_attr.width)
        textures[index]:SetHidden(false)
        -- bottom
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            wnd_attr.hmargin + (i + 1) * digit_attr.width, wnd_attr.top + (num_col + 1) * digit_attr.width)
        textures[index]:SetHidden(false)
        -- left
        index = index + 1
        textures[index]:SetAnchor(TOPLEFT, ESOZH.zhWnd, TOPLEFT,
            wnd_attr.hmargin, wnd_attr.top + (i + 1) * digit_attr.width)
        textures[index]:SetHidden(false)
    end

    -- resize window
    local qr_width = (num_col + 2) * digit_attr.width
    ESOZH.zhWnd:SetDimensions(qr_width + wnd_attr.hmargin * 2, qr_width + wnd_attr.top + wnd_attr.bottom)
end

--** public functions **--

function ESOZH.QR:HideQrcode()
    for i = 1, digit_attr.number do
        textures[i]:SetHidden(true)
    end
end

function ESOZH.QR:ShowTextQrcode(text)
    local ok, tab = qrencode.qrcode(text)
    if ok then
        ShowQrcode(tab)
    end
end

function ESOZH.QR:Initialize()
    for i = 1, digit_attr.number do
        textures[i] = WINDOW_MANAGER:CreateControl("texture"..tostring(i), ESOZH.zhWnd, CT_TEXTURE)
        textures[i]:SetDimensions(digit_attr.width, digit_attr.width)
        textures[i]:SetHidden(true)
        textures[i]:SetTexture('eso_zh/texture/white.dds')
    end
end
