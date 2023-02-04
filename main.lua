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
cam = gamera.new(0, -200, 2000, 90000)
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

    -- Joystick setup
    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

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
    
    -- Initial variables
    gameState = TITLE
    stage = 0
    menu_input_buffer_timer = 1
    -- Debug
    
end

function love.update(dt)

    if gameState == TITLE then
        if love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a")) then
            gameState = TUTORIAL
            menu_input_buffer_timer = 1
            TREE_WIDTH = 10
            TREE_HEIGHT = 50
            total_beetles = 25
        end
    elseif gameState == TUTORIAL then 
        menu_input_buffer_timer = menu_input_buffer_timer - dt
        if menu_input_buffer_timer < 0 and (love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a"))) then
            gameState = RUNNING
            newStage()
        end
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
        cam:setPosition(gameWidth / 2, ratatoskr.y)
        
    end
end

function love.draw()
    push:apply("start")

    if gameState == TITLE then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press Space to Begin")
    elseif gameState == TUTORIAL then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Arrow Keys/D-Pad Move, Hold Space/A/X To Jump In A Direction")
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

function newStage(reset)

    -- If not resetting the current stage, increment the stage counter
    -- and make the tree bigger
    if not reset then 
        stage = stage + 1
        total_beetles = total_beetles + 10
        if stage > 1 then
            TREE_HEIGHT = TREE_HEIGHT + 10
        end
    end

    -- Generate Yggdrasil
    yggdrasil:new_map(TREE_WIDTH, TREE_HEIGHT)

    -- For odd numbered stages, put ratatoskr at the bottom, for even at top
    if stage % 2 ~= 0 then
        ratatoskr.x = math.floor(TREE_WIDTH / 2) * TILE_SIZE
        ratatoskr.y = TREE_HEIGHT * TILE_SIZE
    else
        ratatoskr.x = math.floor(TREE_WIDTH / 2) * TILE_SIZE
        ratatoskr.y = TILE_SIZE
    end

    -- Reset Ratatoskr
    ratatoskr.angle = 0
    ratatoskr.state = WAITING
    ratatoskr.lastpos = {x=ratatoskr.x,y=ratatoskr.y}
    ratatoskr.nextpos = {x=ratatoskr.x,y=ratatoskr.y}
    ratatoskr.death_timer = 2

    -- Empty the beetles table
    destroy_all_beetles()

    -- Spawn New Beetles
    spawn_beetles(total_beetles)
end