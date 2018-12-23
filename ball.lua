local color = require "color"
local utilities = require "utilities"
local sounds = require "sounds"
local object = require "object"
local g = require "globals"
ball = {}
ball.__index = ball
ball.color = color.pink
ball.size = 10
ball.x, ball.y = 20, 20

function ball:new(world, x, y, vx, vy, c)
  local new_ball = {}
  x = x or square.x
  y = y or square.y
  vx = vx or 100
  vy = vy or 100
  c = c or ball.color
  local b = love.physics.newBody(world, x,y, "dynamic")
	local s = love.physics.newCircleShape(ball.size)
	local f = love.physics.newFixture(b,s)
	f:setRestitution(0.8)    -- make it bouncy
  f:setUserData("ball")
  b:setLinearVelocity( vx, vy )
  new_ball = {b=b,s=s,f=f,color = c}
  setmetatable(new_ball,ball)
	return new_ball
end

function ball:draw() --takes a ball object, draws it
  love.graphics.setColor(self.color)

  local x, y = self.b:getPosition()
  local rad = self.s:getRadius()
  love.graphics.circle("fill",x,y,rad, 20)

  -- this is for debug
  local dx,dy = self.b:getLinearVelocity()
  local netd = math.sqrt(dx^2+dy^2)
  --love.graphics.setColor(0,0,255)
  --love.graphics.print(tostring(netd),x,y)
  --love.graphics.setColor(255,0,0)
end

function ball.collision(a)
  local vel_a_x,vel_a_y = a:getBody():getLinearVelocity()
	local vel_a = math.sqrt(vel_a_x^2+vel_a_y^2)
	local note = utilities.interpolate(vel_a,g.max_vel,#sounds.ball)

	love.audio.play(sounds.ball[note])

end

function ball:update(k,worldTable)
		local x, y = self.b:getPosition()--delete fallen balls
		local rad = self.s:getRadius()
		if y > 1.5*rad+love.graphics.getHeight() then
				self.b:destroy()
				table.remove(worldTable, k)
    elseif x > 2.5*rad+love.graphics.getWidth() or x < 0 - 1.5*rad then
      self.b:destroy()
      table.remove(worldTable, k)
		end
end

return ball
