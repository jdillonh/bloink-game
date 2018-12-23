--square_emitter class


local color = require "color"
local g = require "globals"
square_emitter={}
square_emitter.__index = square_emitter

square_emitter.color = color.blue
square_emitter.size = 110
square_emitter.speed = 3 --coeficient of velocity for emitted squares
square_emitter.has_emitted=false
square_emitter.time = 0

function square_emitter:new(world, x, y,color)
  local new_square_emitter
  local color = color or square_emitter.color
  local b = love.physics.newBody(world, x,y, "static")
  local s = love.physics.newRectangleShape(square_emitter.size,square_emitter.size)
  local f = love.physics.newFixture(b,s)
  --time = 0 //time is still a member, it just dont need a decl
  local x_e = x + math.cos(b:getAngle() + math.pi/4) * 7/16 * square_emitter.size ---point of emission X
  local y_e = y + math.sin(b:getAngle() + math.pi/4) * 7/16 * square_emitter.size ---point of emission Y

  f:setRestitution(1.2)    -- make it extra bouncy
  f:setUserData("square_emitter")

  new_square_emitter = {b=b,s=s,f=f,color=color, time=0,
                        has_emitted = false,
                        x_e = x_e,
                        y_e = y_e }
  setmetatable(new_square_emitter,square_emitter)
  return new_square_emitter
end

function square_emitter:draw()
  love.graphics.setColor(square_emitter.color)
  local x, y = self.b:getPosition()
  --love.graphics.circle("fill",x,y,square_emitter.size, 40)
  love.graphics.polygon("fill", self.b:getWorldPoints(self.s:getPoints()))
  love.graphics.setColor(color.dark_blue)
  love.graphics.circle("fill", self.x_e, self.y_e, 5, 10)
end

square_emitter.collision = function(a)
  love.audio.play(sounds.emitter[2])
end


function square_emitter:update()
  local user_data = self.b:getUserData()
-- this is general square_emitter
  if g.time_elapsed  >= g.dt_new_ball-0.1 and not self.has_emitted then
    local x = self.b:getX()
    local y = self.b:getY()
    local new_x = self.x_e + math.cos(self.b:getAngle() - math.pi/4) * 0.6 * square_emitter.size
    local new_y = self.y_e + math.sin(self.b:getAngle()- math.pi/4) * 0.6 * square_emitter.size
    --g.text = "new x is ".. tostring(new_x)
    table.insert(melodyObj,square:new(melody, new_x, new_y,
            (new_x - x)*square_emitter.speed ,(new_y - y)*square_emitter.speed ))
    self.has_emitted = true
  end
if g.time_elapsed == 0 then self.has_emitted = false end

--this is square_emitter_selected
  if mouse.is_clicked
  and utilities.distance(mouse.x,mouse.y,self.b:getX(),self.b:getY())
                                                      < square_emitter.size then
    mouse.is_busy = true
    self.b:setUserData("square_emitter_selected")
  end

  user_data = self.b:getUserData()

  if mouse.is_clicked and user_data == "square_emitter_selected" then
    self.b:setAngle(self.b:getAngle() + mouse.dx * 360/(9*3.14) )

  elseif not mouse.is_clicked and user_data == "square_emitter_selected" then
    self.b:setUserData("square_emitter")
    mouse.is_busy = false
  end

  --actually do the rotation
  local x,y = self.b:getPosition()
  -- self.x_e = x + math.cos(self.b:getAngle()) * 5/8 * square_emitter.size ---point of emission X
  -- self.y_e = y + math.sin(self.b:getAngle()) * 5/8 * square_emitter.size ---point of emission Y
  self.x_e = x + math.cos(self.b:getAngle() - math.pi/4 ) * 0.5 * square_emitter.size
  self.y_e = y + math.sin(self.b:getAngle() - math.pi/4) * 0.5 * square_emitter.size

end






return square_emitter
