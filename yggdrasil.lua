yggdrasil = {}

yggdrasil.tiles = {
    all_dir = love.graphics.newQuad(0, 0, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_right_down = love.graphics.newQuad(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_right_left = love.graphics.newQuad(TILE_SIZE * 2, 0, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_right = love.graphics.newQuad(TILE_SIZE * 3, 0, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_down_left = love.graphics.newQuad(0, TILE_SIZE, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_down = love.graphics.newQuad(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE, maze_tileset),
    up_left = love.graphics.newQuad(TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, TILE_SIZE, maze_tileset),
    up = love.graphics.newQuad(TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, TILE_SIZE, maze_tileset),
    right_down_left = love.graphics.newQuad(0, TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, maze_tileset),
    right_down = love.graphics.newQuad(TILE_SIZE, TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, maze_tileset),
    right_left = love.graphics.newQuad(TILE_SIZE * 2, TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, maze_tileset),
    right = love.graphics.newQuad(TILE_SIZE * 3, TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, maze_tileset),
    down_left = love.graphics.newQuad(0, TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, maze_tileset),
    down = love.graphics.newQuad(TILE_SIZE, TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, maze_tileset),
    left = love.graphics.newQuad(TILE_SIZE * 2, TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, maze_tileset),
    none = love.graphics.newQuad(TILE_SIZE * 3, TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, maze_tileset)
}

function yggdrasil:new_map(width, height)
    self.map = mazegen(width, height)
end
