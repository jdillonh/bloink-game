--help menu
--hold h to bring up menu
local color = require "color"
help={}

help.draw = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  love.graphics.setColor(color.grey)
  love.graphics.setFont(small_sans)
  love.graphics.print("hold \"h\" for help",width*4/5, height*9/10)
  love.graphics.setFont(sans)
 if love.keyboard.isDown("h") then
   love.graphics.setColor(255,255,255)
   love.graphics.draw(help_img, width*1/8 , height*1/8)
   -- love.graphics.print("q for circle emitter \n"..
   --                      "w for square emitter \n"..
   --                      "e to delete projectiles\n"..
   --                      "r to delete e'rythang", width*1/8 , height*1/8)
   --draw the help pictogram
 end

end

return help
