local color = require "color"
local g = require "globals"
paddle ={}
paddle.__index = paddle

paddle.size={x=100,y=50} --the width and height
paddle.color = color.orange


function paddle:new()
  new_paddle={}
  local b = love.physics.newBody(melody, mouse.x,mouse.y, "static")
  local s = love.physics.newRectangleShape(paddle.size.x,paddle.size.y)
	local f = love.physics.newFixture(b,s)
	f:setRestitution(0.8)    -- make it bouncy
	f:setUserData("Paddle_selected")  --store "is_selected?" data here
	local c = color.orange --start off red
  new_paddle = {b=b,s=s,f=f,color =c}
  setmetatable(new_paddle,paddle)
	return new_paddle
end

paddle.make_paddles = function()  --takes mouse.data and makes paddles
  if mouse.frames_clicked == 1 and not mouse.is_busy then
  	table.insert(melodyObj,paddle:new())
    mouse.is_busy = true
  end
end

function paddle:update(k,worldTable)
  if self.f:getUserData()=="Paddle" then return end
  if not mouse.is_clicked then
    self.f:setUserData("Paddle")
    mouse.is_busy=false
  else
    self.b:setAngle(  self.b:getAngle() + mouse.dx/g.dr_factor  )

  end
end

function paddle:draw()
  local x, y = self.b:getPosition()
  local h,w = paddle.size.x , paddle.size.y

  --love.graphics.setColor(color.pink)
  local c1,c2,c3 = love.graphics.getColor()
  love.graphics.setColor(self.color)
  love.graphics.polygon("fill", self.b:getWorldPoints(self.s:getPoints()))
  love.graphics.setColor(c1,c2,c3)
end

return paddle
