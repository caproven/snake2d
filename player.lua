Player = {}
Player.__index = Player

DIR_NONE = 0
DIR_UP = 1
DIR_DOWN = 2
DIR_LEFT = 3
DIR_RIGHT = 4

function Player.create()
  local self = setmetatable({}, Player)

  self.direction = DIR_NONE -- default: no movement until first arrow key pressed
  self.trail = {}
  self.trailMax = 1
  self.dt = 0
  self.ticktime = 0.08 -- seconds per tick
  self.x = 0
  self.y = 0

  return self
end
