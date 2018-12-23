local g = require "globals"
local help = require "help"
local mouse = require "mouse"
local object = require "object"
local ball = require "ball"
local paddle = require "paddle"
local update = require "update"
local color = require "color"
local draw = require "draw"
local sounds = require "sounds"
local utilities = require "utilities"
local emitter = require "emitter"
local square = require "square"
local square_emitter = require "square_emitter"


function love.load()

  love.window.setTitle("bloink")
  sans = love.graphics.newFont("assets/fonts/open_sans.ttf", 64)
  small_sans = love.graphics.newFont("assets/fonts/open_sans.ttf", 20)
  big_sans = love.graphics.newFont("assets/fonts/open_sans.ttf", 100)
  help_img = love.graphics.newImage("assets/pictures/help.png")

  g.width, g.height = love.window.getDesktopDimensions()
  love.window.setMode(g.width * 6/8,g.height * 6/8, {msaa = 128})

  --
  --this is a sound handler: n.o.
  do
      -- will hold the currently playing sources
      local sources = {}

      -- check for sources that finished playing and remove them
      -- add to love.update
      function love.audio.update()
          local remove = {}
          for _,s in pairs(sources) do
              if s:isStopped() then
                  remove[#remove + 1] = s
              end
          end

          --new code
          if #sources > 7 then
            for i,source in pairs(sources) do
              if i >7 then source = nil end
            end
          end
          --end new code

          for i,s in ipairs(remove) do
              sources[s] = nil
          end
      end

      -- overwrite love.audio.play to create and register source if needed
      local play = love.audio.play
      function love.audio.play(what, how, loop)
          local src = what
          if type(what) ~= "userdata" or not what:typeOf("Source") then
              src = love.audio.newSource(what, how)
              src:setLooping(loop or false)
          end

          play(src)
          sources[src] = src
          return src
      end

      -- stops a source
      local stop = love.audio.stop
      function love.audio.stop(src)
          if not src then return end
          stop(src)
          sources[src] = nil
      end
  end
  --end of sound handler
  --

  melodyObj={}
  melody = love.physics.newWorld(0, g.gravity, true)
  melody:setCallbacks(beginContact, endContact, preSolve, postSolve)

end



function love.update(dt)
  melody:update(dt)
  update.tempo()
  update.timers()
  update.mouse()
  update.world(melodyObj)
  paddle.make_paddles()
end

function love.draw()
  love.graphics.clear(color.aqua)
  love.graphics.setColor(255,255,255)
  love.graphics.setFont(sans)
  love.graphics.print("tempo " ..tostring(math.floor(60 * 1/g.dt_new_ball)),
                      10,20,0)

  for k,obj in pairs(melodyObj) do
		obj:draw()
	end

  help.draw()

end

function beginContact(a, b, coll)

  if a:getUserData() == "ball" then
    ball.collision(a)
  end
  if b:getUserData() == "ball" then
    ball.collision(b)
  end

  if a:getUserData() == "emitter" or a:getUserData() == "emitter_selected" then
    emitter.collision(a)

  elseif b:getUserData() == "emitter" or b:getUserData() == "emitter_selected" then
    emitter.collision(b)
  end

  if a:getUserData() == "square" then
    square.collision(a)

  elseif b:getUserData() == "square" then
    square.collision(b)
  end

  if a:getUserData() == "square_emitter" or a:getUserData() == "square_emitter_selected" then
    square_emitter.collision(a)

  elseif b:getUserData() == "square_emitter" or b:getUserData() == "square_emitter_selected" then
    square_emitter.collision(b)
  end


end
