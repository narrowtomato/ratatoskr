-- Table Utility Library
require('lib/table_utils')

-- Maze Generation Library
require('mazegen')

-- Animation library
anim8 = require 'lib/anim8-master/anim8'

-- Push library to scale up our pixel art correctly
local push = require('lib/push')

love.graphics.setDefaultFilter("nearest", "nearest") --disable blurry scaling

TILE_SIZE = 32
TREE_WIDTH = 10
TREE_HEIGHT = 50

gameWidth, gameHeight = TREE_WIDTH * TILE_SIZE + TILE_SIZE * 2, TREE_WIDTH * TILE_SIZE + TILE_SIZE * 2

windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.8, windowHeight*.8

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
    pixelperfect = false
})
push:setBorderColor{0.2, 0.2, 0} --default value
  
function love.resize(w, h)
    push:resize(w, h)
end

-- Camera Library
gamera = require 'lib/gamera-master/gamera'
cam = gamera.new(-200, -200, 2000, 2000)
cam:setWindow(0,0,gameWidth,gameHeight)

function love.load()

    -- Games States
    TITLE = 1
    TUTORIAL = 2
    RUNNING = 3

    -- Entity States
    WAITING = 1
    MOVING_NORTH = 2
    MOVING_SOUTH = 3
    MOVING_EAST = 4
    MOVING_WEST = 5
    ATTACKING = 6
    DEAD = 7
    DOCILE = 8

    -- Make sure numbers are truly random
    math.randomseed(os.time())

    -- Load images and set up animations
    require('imageload')

    -- Yggdrasil Code
    require('yggdrasil')

    -- Ratatoskr Code
    require('ratatoskr')

    -- Beetle Code
    require('beetle')

    -- HUD code
    require('hud')

    -- Controls Code
    require('controls')
    
    -- Generate Yggdrasil
    yggdrasil:new_map(TREE_WIDTH, TREE_HEIGHT)

    -- Spawn Beetles
    spawn_beetles(25)

    gameState = RUNNING
    -- Debug
    
end

function love.update(dt)

    if love.keyboard.isDown('lctrl') then
        gameState = RUNNING
    elseif gameState == RUNNING then
        -- Update Animations
        if ratatoskr.state ~= WAITING then
            ratatoskr_animation:update(dt)
        end

        -- Get Control Input
        getKeyboardInput()

        -- Update Ratatoskr
        ratatoskr:update(dt)

        -- Update Beetles
        update_beetles(dt)

        -- Focus Camera on Player
        if ratatoskr.y / TILE_SIZE > TREE_HEIGHT - gameHeight / TILE_SIZE / 2 then
            cam:setPosition(gameWidth / 2, TREE_HEIGHT * TILE_SIZE - gameHeight / 2 + TILE_SIZE)
        elseif ratatoskr.y / TILE_SIZE < 0 + gameHeight / TILE_SIZE / 2 then
            cam:setPosition(gameWidth / 2, 0 + gameHeight / 2)
        else
            cam:setPosition(gameWidth / 2, ratatoskr.y + TILE_SIZE / 2)
        end
    end
end

function love.draw()
    push:apply("start")

    if gameState == TITLE then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press Control to Begin")
    elseif gameState == TUTORIAL then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Arrow Keys Move, Hold Left Control To Jump In A Direction")
    elseif gameState == RUNNING then
        -- Draw Background
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0,0, gameWidth,gameHeight)

        -- Draw Camera Stuff
        cam:draw(drawCameraStuff)

        -- Draw HUD
        hud:draw()
    end

    push:apply("end")
end

function drawCameraStuff()
    -- Draw Yggdrasil
    love.graphics.setColor(1, 1, 1)
    for i,row in ipairs(yggdrasil.map) do
        for j,tile in ipairs(row) do
            if tile == 0 then love.graphics.draw(maze_tileset, yggdrasil.tiles.all_dir, ((j - 1)) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 1 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right_down, ((j - 1)) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 2 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 3 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 4 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_down_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 5 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_down, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 6 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 7 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 8 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_down_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 9 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_down, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 10 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 11 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 12 then love.graphics.draw(maze_tileset, yggdrasil.tiles.down_left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 13 then love.graphics.draw(maze_tileset, yggdrasil.tiles.down, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 14 then love.graphics.draw(maze_tileset, yggdrasil.tiles.left, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 15 then love.graphics.draw(maze_tileset, yggdrasil.tiles.none, (j - 1) * TILE_SIZE + TILE_SIZE, (i - 1) * TILE_SIZE) end
        end
    end

    ratatoskr:draw()

    draw_beetles()
end

-- Calculates distance between two points
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end