-- for general purpose / golbal var
--updates  o n l y
--other updates belong to their classes
--*update.world() will call each objects update method
local g = require "globals"

update = {}

update.tempo = function()
	if love.keyboard.isDown("down") then
		g.dt_new_ball = g.dt_new_ball + 0.01
	end
	if love.keyboard.isDown("up") then
		g.dt_new_ball = g.dt_new_ball - 0.01
	end

	if g.dt_new_ball <= g.min_dt_new_ball then
		g.dt_new_ball = g.min_dt_new_ball
	elseif g.dt_new_ball >= g.max_dt_new_ball then
		g.dt_new_ball = g.max_dt_new_ball
	end
end


update.timers = function()
g.time_elapsed = g.time_elapsed + love.timer.getDelta()
	if g.time_elapsed>= g.dt_new_ball then
		g.time_elapsed=0
	end
end

update.mouse = function()
	if love.mouse.isDown(1) then  --1 means left click
		mouse.is_clicked = true
		mouse.frames_clicked = mouse.frames_clicked + 1
			--^this^ will = 1 on the first click frame
	else
		mouse.is_clicked = false
		mouse.frames_clicked=0
	end
	mouse.dx = love.mouse.getX() - mouse.x
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()

end




--worldTable: table of all objects in a world: i.e. melodyObj etc.
update.world = function(worldTable)

	if love.keyboard.isDown("q") and not g.spacePressed then
    table.insert(worldTable,emitter:new(melody, mouse.x,mouse.y))
	   g.spacePressed = true
	 elseif not love.keyboard.isDown("q") then
		  g.spacePressed = false
	end

	if love.keyboard.isDown("w") and not g.square_emitter_created then
    table.insert(worldTable,square_emitter:new(melody, mouse.x,mouse.y))
	   g.square_emitter_created = true
	 elseif not love.keyboard.isDown("w") then
		  g.square_emitter_created = false
	end

	if love.keyboard.isDown("r") then --take q to delete all objets
		for k,obj in pairs(worldTable) do
			obj.b:destroy()
			table.remove(worldTable,k)
		end
	end

	if love.keyboard.isDown("e") then -- take w to clear projectiles
		for k,obj in pairs(worldTable) do
			if obj.f:getUserData()=="ball" or obj.f:getUserData() == "square" then
				obj.b:destroy()
				table.remove(worldTable,k)
			end
		end
	end

	for k,obj in pairs(worldTable) do
		obj:update(k,worldTable)
	end
end


return update
