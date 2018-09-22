
local is_jumping = false

local mon1 = {
  x = 0,
  y = 0,
  w = 32,
  h = 32,
}

local ai = {}

function ai:follow()
  self.x = self.x + (self)
end


function love.load()

  timer = {t = 1/60, dt = 0}
  clock = 0
  obj = {x=80,y=100,w=32,h=32,xm=12,ym=16,dx=0,dy=0,collisions={}}
  wall = {x=400,y=300,w=500,h=80,xm=250,ym=40}
  
  
  map = makeMap()
  str = ""
end

function love.update(dt)
  timer.dt = timer.dt + dt
  
  while timer.dt > timer.t do
    --obj.x,obj.y = love.mouse.getPosition()

    
    obj.dy = obj.dy + .5
    if obj.dy > 8 then obj.dy = 8 end
    if obj.dx > 4 then obj.dx = 4 end
    if obj.dx < -4 then obj.dx = -4 end
    obj.y = obj.y + obj.dy
    obj.x = obj.x + obj.dx
    
    
    getMapCollisions(obj,map)
    
    if love.keyboard.isDown("left") then obj.dx = obj.dx - 1 end
    if love.keyboard.isDown("right") then obj.dx = obj.dx + 1 end
    if love.keyboard.isDown("z") and not is_jumping then
      obj.dy = -11
      is_jumping = true
      
      end
    
    
    
    --if obj.x > map.w*map.tw-obj.w then obj.x = map.w*map.tw-obj.w end
    clock = clock + timer.t
    timer.dt = timer.dt - timer.t
  end
  
end

function love.mousepressed(x,y,b)
  if b == "1" then
    obj.xm = obj.xm + 1
    --obj.ym = obj.ym + 1
  end
  if b == "2" then
    obj.xm = obj.xm - 1
    --obj.ym = obj.ym - 1
    end
  
end

function love.draw()
  
  love.graphics.setColor(255,0,0)
  --love.graphics.rectangle("fill",wall.x-wall.xm,wall.y-wall.ym,wall.w,wall.h)
  drawMap(map)
  
  love.graphics.setColor(0,255,0,100)
  love.graphics.rectangle("fill",obj.x-obj.xm,obj.y-obj.ym,obj.xm*2,obj.ym*2)
 
  love.graphics.setColor(255,255,255)
  --local x,y = getMajorAxis(obj,wall)
  love.graphics.print(str,16,32)

end


function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function isInternalCollision(tile, hit)
  local x = hit.normal_x or 0
  local y = hit.normal_y or 0
  local tile_i = tile
  
  tile_i = tile_i - y*map.w
  tile_i = tile_i - x
  if map[tile_i] and map[tile_i] > 0 then return true end
end

function getMapCollisions(obj,map)
  local x, y
  local collisions = {}
  for i = 1, #map do
    if map[i] > 0 then
      local tile = {x=((i-1)%map.w)*map.tw, y=math.ceil(i/map.w)*map.th, xm=map.xm, ym=map.ym}
      local hit = intersectAABB(obj,tile)
      
      if hit then
        if not isInternalCollision(i,hit) then
          resolveMapCollisions(obj, hit)
          is_jumping = false
        end
      end
    end
  end
  return collisions
end

function resolveMapCollisions(obj, hit)
  if hit.normal_x and (sign(hit.normal_x) == sign(obj.dx)) then
    obj.dx = 0
    obj.x = obj.x - hit.dx
  end
  
  if hit.normal_y then
    obj.dy = 0
    obj.y = obj.y - hit.dy
    if obj.dx > 0 then
      obj.dx = obj.dx - .25
      if obj.dx < 0 then obj.dx = 0 end
    end
    if obj.dx < 0 then
      obj.dx = obj.dx + .25
      if obj.dx > 0 then obj.dx = 0 end
    end
  end
    
  if hit.dx then
    
  else

  end
  
end

function getMapTile(map,x,y)
  if x < 1 or y < 1 or x > map.w*map.tw or y > map.h*map.th then return nil end
  return (y*map.w)-map.w+x
end

  
function makeMap()
  local map = 
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
   1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,
   1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
   1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,
   1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
   1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
   }
   --[[map =
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
   0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   }]]

  map.w = 16
  map.h = 12
  map.tw = 32
  map.th = 32
  map.xm = 16
  map.ym = 16
  return map
end

function drawMap(map)
  for y = 1, map.h do
    for x = 1, map.w do
      if map[(y-1)*map.w+x] > 0 then
        love.graphics.rectangle("line",x*map.tw-map.tw-map.xm,y*map.th-map.ym,map.tw,map.th)
      end
    end
  end
  
end

-- New functions for better AABB after this point.

function sign(val)
  if val < 0 then
    return -1
  else
    return 1
  end
end


function normalize(self)
  local length = self.x * self.x + self.y + self.y
  if length > 0 then
    length = math.sqrt(length)
    local inverse_length = 1 / length
    self.x = self.x * inverseLength
    self.y = self.y * inverseLength
    return length
  end
end

function intersectAABB(self,box)
  local dx = box.x - self.x
  local px = (box.xm + self.xm) - math.abs(dx)
  if px <= 0 then return end
  
  local dy = box.y - self.y
  local py = (box.ym + self.ym) - math.abs(dy)
  if py <= 0 then return end
  
  local hit = {}
  if px < py then
    local sx = sign(dx)
    hit.dx = px*sx
    hit.normal_x = sx

    hit.x = box.x + (box.xm * sx)
    hit.y = self.y
  else
    local sy = sign(dy)
    hit.dy = py*sy
    hit.normal_y = sy

    hit.x = self.x
    hit.y = box.y + (box.ym * sy)
  end
  return hit
end
