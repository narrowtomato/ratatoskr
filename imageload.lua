-- Maze
maze_tileset = love.graphics.newImage('img/tree-tiles.png')

-- Ratatoskr
ratatoskr_image = love.graphics.newImage('img/squirrel.png')
ratatoskr_anim_grid = anim8.newGrid(32, 32, ratatoskr_image:getWidth(), ratatoskr_image:getHeight())
ratatoskr_run_animation = anim8.newAnimation(ratatoskr_anim_grid('3-4', 1), 0.1)
ratatoskr_idle_animation = anim8.newAnimation(ratatoskr_anim_grid('1-2', 1), 0.1)

-- Beetle
beetle_image_1 = love.graphics.newImage('img/beetle.png')
beetle_image_2 = love.graphics.newImage('img/beetle2.png')
beetle_image_3 = love.graphics.newImage('img/beetle3.png')

beetle_anim_grid_1 = anim8.newGrid(32, 32, beetle_image_1:getWidth(), beetle_image_1:getHeight())
beetle_anim_grid_2 = anim8.newGrid(32, 32, beetle_image_2:getWidth(), beetle_image_1:getHeight())
beetle_anim_grid_3 = anim8.newGrid(32, 32, beetle_image_3:getWidth(), beetle_image_1:getHeight())

beetle_1_animation = anim8.newAnimation(beetle_anim_grid_1('1-2', 1), 0.1)
beetle_2_animation = anim8.newAnimation(beetle_anim_grid_2('1-2', 1), 0.1)
beetle_3_animation = anim8.newAnimation(beetle_anim_grid_3('1-2', 1), 0.1)

-- Crow
crow_image = love.graphics.newImage('img/raven.png')

-- Background
background_image = love.graphics.newImage('img/clouds.png')
background_image:setWrap("repeat", "repeat")
bg_quad = love.graphics.newQuad(0, 0, 9999999, 9999999, background_image:getWidth(), background_image:getHeight())
background_scroll_factor = 1

-- Nidhogg
nidhogg_image = love.graphics.newImage('img/nidhogg.png')
nidhogg_anim_grid = anim8.newGrid(nidhogg_image:getWidth() / 2, nidhogg_image:getHeight() / 2, nidhogg_image:getWidth(), nidhogg_image:getHeight())
nidhogg_animation = anim8.newAnimation(nidhogg_anim_grid('1-2', '1-2'), 0.2)

-- Font
font = love.graphics.newFont("fonts/NaughtySquirrelDemo-yrn2.ttf", 20)
love.graphics.setFont(font)