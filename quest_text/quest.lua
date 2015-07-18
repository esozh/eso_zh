-- -*- coding: utf-8 -*-
-- created by bssthu

ESOZH.QUEST = {}

local Origin_InteractWindow_SetText= ZO_InteractWindowTargetAreaBodyText.SetText

--** public functions **--

ZO_InteractWindowTargetAreaBodyText.SetText = function (self, bodyText)
    d(bodyText)
    Origin_InteractWindow_SetText(self, bodyText)
end

function ESOZH.QUEST:Initialize()
end
