local color = require "color"
local g = require "globals"
emitter={}
emitter.__index = emitter

emitter.color = color.pink
emitter.size = 60
emitter.speed = 5
emitter.has_emitted=false
emitter.time = 0

function emitter:new(world, x, y,color)
  local new_emitter = {}

  local color = color or emitter.color
  local b = love.physics.newBody(world, x,y, "static")
  local s = love.physics.newCircleShape(emitter.size)
  local f = love.physics.newFixture(b,s)
  --local time = 0 time is still a member, it just dont need a decl here
  local x_e = x + math.cos(b:getAngle()) * 5/8 * emitter.size ---point of emission X
  local y_e = y + math.sin(b:getAngle()) * 5/8 * emitter.size ---point of emission Y

  f:setRestitution(1.2)    -- make it extra bouncy
  f:setUserData("emitter")

  new_emitter = {b=b,s=s,f=f,color=color, time=0,
                has_emitted = false,
                x_e = x_e,
                y_e = y_e }
  setmetatable(new_emitter,emitter)
  return new_emitter
end

function emitter:draw()
  --error("we got here")
  love.graphics.setColor(color.pink)
  local x, y = self.b:getPosition()
  local rad = self.s:getRadius()
  love.graphics.circle("fill",x,y,rad, 40)
  love.graphics.setColor(color.purple)
  love.graphics.circle("fill", self.x_e, self.y_e, 5, 10)
end

emitter.collision = function(a)
  love.audio.play(sounds.emitter[1])
end


function emitter:update()
  local user_data = self.b:getUserData()
-- this is general emitter
  if g.time_elapsed  >= g.dt_new_ball-0.1 and not self.has_emitted then
    local x = self.b:getX()
    local y = self.b:getY()
    local new_x = self.x_e + math.cos(self.b:getAngle()) * 0.7 * emitter.size
    local new_y = self.y_e + math.sin(self.b:getAngle()) * 0.7 * emitter.size
    --g.text = "new x is ".. tostring(new_x)
    table.insert(melodyObj,ball:new(melody, new_x, new_y,
            (new_x - x)*emitter.speed ,(new_y - y)*emitter.speed ))
    self.has_emitted = true
  end
if g.time_elapsed == 0 then self.has_emitted = false end

--this is emitter_selected
  if mouse.is_clicked
  and utilities.distance(mouse.x,mouse.y,self.b:getX(),self.b:getY())
                                                      < emitter.size then
    mouse.is_busy = true
    self.b:setUserData("emitter_selected")
  end

  user_data = self.b:getUserData()

  if mouse.is_clicked and user_data == "emitter_selected" then
    self.b:setAngle(self.b:getAngle() + mouse.dx * 360/(9*3.14) )

  elseif not mouse.is_clicked and user_data == "emitter_selected" then
    self.b:setUserData("emitter")
    mouse.is_busy = false
  end

  --actualy do the rotation
  local x,y = self.b:getPosition()
  self.x_e = x + math.cos(self.b:getAngle()) * 5/8 * emitter.size ---point of emission X
  self.y_e = y + math.sin(self.b:getAngle()) * 5/8 * emitter.size ---point of emission Y

end






return emitter
