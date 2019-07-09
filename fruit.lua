Fruit = {}
Fruit.__index = Fruit

function Fruit:create()
  local self = setmetatable({}, Fruit)

  self.x = 50
  self.y = 50

  return self
end
