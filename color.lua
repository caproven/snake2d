Color = {}
Color.__index = Color

function Color:create(r, g, b)
  local self = setmetatable({}, Color)

  self.r = r
  self.g = g
  self.b = b
  
  return self
end

-- function Color:__call(...)
--   local inst = setmetatable({}, self)
--   inst:create(...)
--   return inst
-- end

function Color:get()
  return self.r, self.g, self.b
end

function Color:getLove()
  return self.r / 255, self.g / 255, self.b / 255
end
