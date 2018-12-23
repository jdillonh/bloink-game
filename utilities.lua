--utilities
utilities = {}


--used to determine sound based on velocity
--num_sounds = number of sounds
utilities.interpolate = function(obj_vel,max_vel,num_sounds)
	local n = math.floor(1 + (obj_vel/max_vel)*(num_sounds))
	if n > num_sounds then n = num_sounds end
	if n < 1 then n = 1 end
	return n
end

--simple distance formula
utilities.distance = function(x1,y1,x2,y2)
return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

return utilities
