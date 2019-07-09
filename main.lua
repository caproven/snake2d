require 'color'
require 'player'
require 'fruit'

-- vars
local bgColor = nil
local playerColor = nil
local trailColor = nil
local fruitColor = nil

local player = nil

gridDelta = 50

local score = 1

local fruit = nil

-- initialize stuff
function love.load()
  math.randomseed(os.time()) -- so that fruit pos is different each time

  bgColor = Color:create(255, 204, 204)
  playerColor = Color:create(255, 102, 153)
  trailColor = Color:create(255, 255, 255)
  fruitColor = Color:create(204, 255, 153)

  player = Player:create()
  fruit = Fruit:create()
end

-- update game state
function love.update(dt)
  -- handle direction changing
  if love.keyboard.isDown('left', 'a') then
    player.direction = DIR_LEFT
  elseif love.keyboard.isDown('right', 'd') then
    player.direction = DIR_RIGHT
  elseif love.keyboard.isDown('up', 'w') then
    player.direction = DIR_UP
  elseif love.keyboard.isDown('down', 's') then
    player.direction = DIR_DOWN
  end

  -- update player time
  if player.dt > 0 then
    player.dt = player.dt - dt
  else
    -- update player trail
    if player.direction ~= DIR_NONE then -- only update trail if moving
      if player.trailMax ~= 0 then
        if table.maxn(player.trail) >= player.trailMax then
          table.remove(player.trail, 1)
        end
        table.insert(player.trail, {
          x = player.x,
          y = player.y
        })
      end
    end
    -- update player position
    player.dt = player.ticktime
    if player.direction == DIR_LEFT then
      player.x = player.x - gridDelta
    elseif player.direction == DIR_RIGHT then
      player.x = player.x + gridDelta
    elseif player.direction == DIR_UP then
      player.y = player.y - gridDelta
    elseif player.direction == DIR_DOWN then
      player.y = player.y + gridDelta
    end
  end

  -- detect collision with fruit
  if equalCoords(fruit.x, player.x, fruit.y, player.y) then
    player.trailMax = player.trailMax + 3
    score = player.trailMax
    randomizeFruitPos()
  end

  -- detect collision with window border
  if player.x < 0 or player.x + gridDelta > love.graphics.getWidth() or
      player.y < 0 or player.y + gridDelta > love.graphics.getHeight() then
    os.exit()
  end
  -- detect collision with trail
  local trailLen = table.maxn(player.trail)
  for i=1,trailLen,1 do
    local x, y = player.trail[i].x, player.trail[i].y
    if equalCoords(x, player.x, y, player.y) then
      os.exit()
    end
  end
end

-- draw screen
function love.draw()
  love.graphics.clear(bgColor:getLove())

  -- draw trail
  love.graphics.setColor(trailColor:getLove())
  local trailLen = table.maxn(player.trail)
  for i=1,trailLen do
    x, y = player.trail[i].x, player.trail[i].y
    love.graphics.rectangle("fill", x, y, gridDelta, gridDelta)
  end

  -- draw fruit
  love.graphics.setColor(fruitColor:getLove())
  love.graphics.rectangle("fill", fruit.x, fruit.y, gridDelta, gridDelta)

  -- draw player
  love.graphics.setColor(playerColor:getLove())
  love.graphics.rectangle("fill", player.x, player.y, gridDelta, gridDelta)

  -- draw score
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("SCORE: " .. score)

  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 20)
end

function randomizeFruitPos()
  local maxGridX = love.graphics.getWidth() / gridDelta - 1 -- max # of grid cells
  local maxGridY = love.graphics.getHeight() / gridDelta - 1

  local newx, newy
  local trailLen = table.maxn(player.trail)

  local collideTrail, collidePlayer
  repeat
    collideTrail = false
    collidePlayer = false
    newx = math.random(0, maxGridX) * gridDelta
    newy = math.random(0, maxGridY) * gridDelta
    -- if there is a collision between new pos and trail or player, generate new pos
    for i=1,trailLen do
      local x, y = player.trail[i].x, player.trail[i].y
      if equalCoords(x, newx, y, newy) then
        collideTrail = true
        break
      end
    end
    if equalCoords(newx, player.x, newy, player.y) then
      collidePlayer = true
    end
  until not collideTrail and not collidePlayer

  fruit.x = newx
  fruit.y = newy
  print('updated fruit pos')
end

function equalCoords(x1, x2, y1, y2)
  return x1 == x2 and y1 == y2
end
