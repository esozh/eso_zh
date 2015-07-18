-- -*- coding: utf-8 -*-
-- created by bssthu

local _M = {}


--** public functions **--

function _M.Initialize()
end


--** return **--

_M.__index = _M

function _M:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, _M)
end

ESOZH.QUEST = _M:new()
