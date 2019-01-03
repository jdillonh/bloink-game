local object = require "object"--no longer in use
local ball = require "ball"
local emitter = require "emitter"
draw = {}



draw.world = function(worldTable)  --table of all objects in a world: i.e. melodyObj etc.

	for k,obj in pairs(worldTable) do
		obj:draw()
	end


end




return draw
