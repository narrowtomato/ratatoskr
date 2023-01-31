-- Table Utility Library
require('lib/table_utils')

-- Maze Generation Library
require('mazegen')

-- Push library to scale up our pixel art correctly
local push = require('lib/push')

love.graphics.setDefaultFilter("nearest", "nearest") --disable blurry scaling

TILE_SIZE = 4
TREE_WIDTH = 10
TREE_HEIGHT = 10

gameWidth, gameHeight = TILE_SIZE * TREE_WIDTH, TILE_SIZE * TREE_HEIGHT + TILE_SIZE

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

function love.load()

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

    -- HUD code
    require('hud')

    -- Controls Code
    require('controls')
    
    -- Generate Yggdrasil
    yggdrasil:new_map(TREE_WIDTH, TREE_HEIGHT)

    -- Debug
    
end

function love.update(dt)

    -- Get Control Input
    getKeyboardInput()

    -- Update Ratatoskr
    ratatoskr:update(dt)

    canMoveDirection(ratatoskr, "dir")

end

function love.draw()
    push:apply("start")

    -- Draw Background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0,0, gameWidth,gameHeight)

    -- Draw Yggdrasil
    love.graphics.setColor(1, 1, 1)
    for i,row in ipairs(yggdrasil.map) do
        for j,tile in ipairs(row) do
            if tile == 0 then love.graphics.draw(maze_tileset, yggdrasil.tiles.all_dir, ((j - 1)) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 1 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right_down, ((j - 1)) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 2 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 3 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_right, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 4 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_down_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 5 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_down, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 6 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 7 then love.graphics.draw(maze_tileset, yggdrasil.tiles.up, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 8 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_down_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 9 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_down, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 10 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 11 then love.graphics.draw(maze_tileset, yggdrasil.tiles.right, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 12 then love.graphics.draw(maze_tileset, yggdrasil.tiles.down_left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 13 then love.graphics.draw(maze_tileset, yggdrasil.tiles.down, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 14 then love.graphics.draw(maze_tileset, yggdrasil.tiles.left, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
            if tile == 15 then love.graphics.draw(maze_tileset, yggdrasil.tiles.none, (j - 1) * TILE_SIZE, (i - 1) * TILE_SIZE) end
        end
    end

    ratatoskr:draw()

    push:apply("end")
end

