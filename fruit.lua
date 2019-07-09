Fruit = {}
Fruit.__index = Fruit

function Fruit:create()
  local self = setmetatable({}, Fruit)

  self.x = gridDelta
  self.y = gridDelta

  return self
end
