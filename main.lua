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
TREE_HEIGHT = 30

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

-- comment
-- Camera Library
gamera = require 'lib/gamera-master/gamera'
cam = gamera.new(0, -200, 2000, 90000)
cam:setWindow(0,0,gameWidth,gameHeight)

function love.load()

    -- Games States
    TITLE = 1
    TUTORIAL = 2
    RUNNING = 3
    INTERMISSION = 4
    END = 5

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

    -- Sound Setup
    require('sounds')

    -- Load images and set up animations
    require('imageload')

    -- Yggdrasil Code
    require('yggdrasil')

    -- Ratatoskr Code
    require('ratatoskr')

    -- Beetle Code
    require('beetle')

    -- Crow Code
    require('crow')

    -- HUD code
    require('hud')

    -- Controls Code
    require('controls')
    
    -- Initial variables
    gameState = TITLE
    stage = 0
    menu_input_buffer_timer = 0.5
    lives = 3
    -- Debug
    
end

function love.update(dt)

    if gameState == TITLE then
        if not sounds.title_music:isPlaying() then
            love.audio.stop()
            sounds.title_music:play()
        end
        logo_animation:update(dt)

        menu_input_buffer_timer = menu_input_buffer_timer - dt
        if menu_input_buffer_timer < 0 and (love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a"))) then
            gameState = TUTORIAL
            menu_input_buffer_timer = 0.5
            TREE_WIDTH = 10
            TREE_HEIGHT = 30
            stage = 0
        end
    elseif gameState == TUTORIAL then 
        menu_input_buffer_timer = menu_input_buffer_timer - dt
        if menu_input_buffer_timer < 0 and (love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a"))) then
            menu_input_buffer_timer = 0.5
            gameState = RUNNING
            lives = 3
            newStage()
        end
    elseif gameState == INTERMISSION then
        nidhogg_animation:update(dt)
        eagle_animation:update(dt)

        menu_input_buffer_timer = menu_input_buffer_timer - dt
        if menu_input_buffer_timer < 0 and (love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a"))) then
            menu_input_buffer_timer = 0.5
            gameState = RUNNING
            newStage()
        end
    elseif gameState == END then 
        if sounds.music1:isPlaying() or sounds.music2:isPlaying() then
            love.audio.stop()
        end
        menu_input_buffer_timer = menu_input_buffer_timer - dt
        if menu_input_buffer_timer < 0 and (love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a"))) then
            menu_input_buffer_timer = 0.5
            gameState = TITLE
            newStage()
        end
    elseif gameState == RUNNING then

        -- Play Music
        if not sounds.music1:isPlaying() and stage % 2 ~= 0 then
            love.audio.stop()
            love.audio.play(sounds.music1)
        elseif not sounds.music2:isPlaying() and stage % 2 == 0 then
            love.audio.stop()
            love.audio.play(sounds.music2)
        end

        -- Update Animations
        ratatoskr_run_animation:update(dt)
        ratatoskr_idle_animation:update(dt)
        beetle_1_animation:update(dt)
        beetle_2_animation:update(dt)
        beetle_3_animation:update(dt)
        crow_idle_animation:update(dt)
        crow_fly_animation:update(dt)
        background_scroll_factor = background_scroll_factor - dt * 10

        -- Get Control Input
        getKeyboardInput()

        -- Update Ratatoskr
        ratatoskr:update(dt)

        -- Update Beetles
        update_beetles(dt)

        -- Update Crows
        update_crows(dt)

        -- Focus Camera on Player
        cam:setPosition(gameWidth / 2, ratatoskr.y)
        
    end
end

function love.draw()
    push:apply("start")

    if gameState == TITLE then
        love.graphics.setColor(1, 1, 1)
        logo_animation:draw(logo_image, gameWidth / 2 - logo_image:getWidth() / 2, 10)
        love.graphics.printf("Programming by Narrowtomato", 0, 150, gameWidth, "center")
        love.graphics.printf("Art by Timconceivable", 0, 200, gameWidth, "center")
        love.graphics.printf("Sound by Mitchell Davis", 0, 250, gameWidth, "center")
        love.graphics.printf("Press Space/A/X to Begin!", 0, 350, gameWidth, "center")
    elseif gameState == TUTORIAL then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Arrow Keys/D-Pad Move", 0, 50, gameWidth, "center")
        love.graphics.printf("Hold Space/A/X To Jump", 0, 150, gameWidth, "center")
        love.graphics.printf("Press Esc/Start to Quit", 0, 250, gameWidth, "center")
    elseif gameState == INTERMISSION then
        love.graphics.setColor(1, 1, 1)
        if stage % 2 ~= 0 then
            eagle_animation:draw(eagle_image, 0, 100)
            love.graphics.draw(sqr_image, 250, 100, nil, 0.10)
            love.graphics.print("You Reached The Top")
            love.graphics.print("Press Jump for the next Stage", 0, 50)
        else
            nidhogg_animation:draw(nidhogg_image, 0, 100)
            love.graphics.draw(sqr_image, 250, 100, nil, 0.10)
            love.graphics.print("You Reached The Bottom")
            love.graphics.print("Press Jump for the next Stage", 0, 50)
        end
    elseif gameState == END then
        love.graphics.printf("GAME OVER", 0, 50, gameWidth, "center")
        love.graphics.printf("You made it to stage: " .. stage, 0, 100, gameWidth, "center")
        love.graphics.printf("Programming by Narrowtomato", 0, 150, gameWidth, "center")
        love.graphics.printf("Art by Timconceivable", 0, 200, gameWidth, "center")
        love.graphics.printf("Sound by Mitchell Davis", 0, 250, gameWidth, "center")
        love.graphics.printf("Press Space/A/X to return", 0, 350, gameWidth, "center")

    elseif gameState == RUNNING then
        -- Draw Background
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 10, 0)
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 300, background_image:getHeight())
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 500, background_image:getHeight() * 2)
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 200, background_image:getHeight() * 3)
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 0, background_image:getHeight() * 4)
        love.graphics.draw(background_image, bg_quad, background_scroll_factor - 10, background_image:getHeight() * 5)

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

    draw_crows()
end

-- Calculates distance between two points
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function newStage(reset)

    if not reset then
        stage = stage + 1
        TREE_HEIGHT = TREE_HEIGHT + 10
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

    -- Empty and spawn new beetles
    destroy_all_beetles()
    spawn_beetles(stage * 10, stage * 20)

    -- Empty and spawn new crows
    destroy_all_crows()
    spawn_crows(stage, stage * 70)
end