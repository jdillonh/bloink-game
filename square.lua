--square class

local color = require "color"
local utilities = require "utilities"
local sounds = require "sounds"
local g = require "globals"
square = {}
square.__index = square
square.color = color.blue
square.size = 20
square.x, square.y = 20, 20

function square:new(world, x, y, vx, vy, c)
  local new_square = {}
  x = x or square.x
  y = y or square.y
  vx = vx or 100
  vy = vy or 100
  c = c or square.color
  local b = love.physics.newBody(world, x,y, "dynamic")
	local s = love.physics.newRectangleShape(square.size, square.size)
	local f = love.physics.newFixture(b,s)
	f:setRestitution(0.8)    -- make it bouncy
  f:setUserData("square")
  b:setLinearVelocity( vx, vy )
  new_square = {b=b,s=s,f=f,color = c}
  setmetatable(new_square,square)
	return new_square
end

function square:draw( color) --takes a square object, draws it
  love.graphics.setColor(self.color)

  local x, y = self.b:getPosition()
  --love.graphics.rectangle("fill", x, y, square.size, square.size)
  --love.graphics.polygon("fill", obj.b:getShape():getPoints())
  love.graphics.polygon("fill", self.b:getWorldPoints(self.s:getPoints()))

  -- this is for debug
  -- local dx,dy = obj.b:getLinearVelocity()
  -- local netd = math.sqrt(dx^2+dy^2)
  --love.graphics.setColor(0,0,255)
  --love.graphics.print(tostring(netd),x,y)
  --love.graphics.setColor(255,0,0)
end


function square:update(k,worldTable)
		local x, y = self.b:getPosition()--delete fallen squares
		--local rad = obj.s:getRadius()
		if y > 5*square.size + love.graphics.getHeight() then
				self.b:destroy()
				table.remove(worldTable, k)
		end
end

square.collision = function(a)
  local vel_a_x,vel_a_y = a:getBody():getLinearVelocity()
	local vel_a = math.sqrt(vel_a_x^2+vel_a_y^2)
	local note = utilities.interpolate(vel_a,g.max_vel,#sounds.square)

	love.audio.play(sounds.square[note])

end


return square
