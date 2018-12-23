--base class for game objects
--we might not actually need this oh well...

object = {}


--virtual update function for classes w/o one
function object:update()
end

function object:draw()
  error("we got the virtual draw")
end

return object
