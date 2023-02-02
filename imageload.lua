maze_tileset = love.graphics.newImage('img/tree-tiles.png')

ratatoskr_image = love.graphics.newImage('img/squirrel.png')
ratatoskr_anim_grid = anim8.newGrid(32, 32, ratatoskr_image:getWidth(), ratatoskr_image:getHeight())
ratatoskr_animation = anim8.newAnimation(ratatoskr_anim_grid('1-2', 1), 0.1)