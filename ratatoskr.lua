ratatoskr = {}

ratatoskr.ENERGY_GAIN_RATE = 500
ratatoskr.MAX_ENERGY = 500
ratatoskr.JUMP_DEPLETE = 499


ratatoskr.death_timer = 2
ratatoskr.x = math.floor(TREE_WIDTH / 2) * TILE_SIZE
ratatoskr.y = TREE_HEIGHT * TILE_SIZE
ratatoskr.radius = 10
ratatoskr.speed = 150
ratatoskr.state = WAITING
ratatoskr.lastpos = {x=ratatoskr.x,y=ratatoskr.y}
ratatoskr.nextpos = {x=ratatoskr.x,y=ratatoskr.y}
ratatoskr.energy = ratatoskr.MAX_ENERGY
ratatoskr.angle = 0

function ratatoskr:update(dt)
    -- ratatoskr movement
    if ratatoskr.state == MOVING_NORTH then
        ratatoskr.angle = 0
        ratatoskr.y = ratatoskr.y - ratatoskr.speed * dt
        if ratatoskr.y <= ratatoskr.nextpos.y then
            ratatoskr.y = ratatoskr.nextpos.y
            ratatoskr.lastpos.y = ratatoskr.y
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_SOUTH then
        ratatoskr.angle = math.pi
        ratatoskr.y = ratatoskr.y + ratatoskr.speed * dt
        if ratatoskr.y >= ratatoskr.nextpos.y then
            ratatoskr.y = ratatoskr.nextpos.y
            ratatoskr.lastpos.y = ratatoskr.y
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_EAST then
        ratatoskr.angle = math.pi / 2
        ratatoskr.x = ratatoskr.x + ratatoskr.speed * dt
        if ratatoskr.x >= ratatoskr.nextpos.x then
            ratatoskr.x = ratatoskr.nextpos.x
            ratatoskr.lastpos.x = ratatoskr.x
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_WEST then
        ratatoskr.angle = 3 * math.pi / 2
        ratatoskr.x = ratatoskr.x - ratatoskr.speed * dt
        if ratatoskr.x <= ratatoskr.nextpos.x then
            ratatoskr.x = ratatoskr.nextpos.x
            ratatoskr.lastpos.x = ratatoskr.x
            ratatoskr.state = WAITING
        end
    end

    -- Restore Energy
    if ratatoskr.energy < ratatoskr.MAX_ENERGY then
        ratatoskr.energy = ratatoskr.energy + ratatoskr.ENERGY_GAIN_RATE * dt
    end

    -- Detect collisions with enemy
    for k,beetle in pairs(beetles) do
        if distanceBetween(ratatoskr.x, ratatoskr.y, beetle.x, beetle.y) < ratatoskr.radius + beetle.radius then
            ratatoskr.state = DEAD
            sounds.hurt:play()
        end
    end

    for k,crow in pairs(crows) do
        if distanceBetween(ratatoskr.x, ratatoskr.y, crow.x, crow.y) < ratatoskr.radius + crow.radius then
            ratatoskr.state = DEAD
            sounds.hurt:play()
        end
    end

    -- Spin when dead
    if ratatoskr.state == DEAD then
        ratatoskr.angle = love.math.random(0, math.pi * 2)
        ratatoskr.death_timer = ratatoskr.death_timer - dt

        if ratatoskr.death_timer < 0 then
            gameState = END
        end
    end

    -- Detect stage win state
    if ratatoskr.state == WAITING then 
        -- Get the maze y position to determine if on edge
        local maze_position_y = ratatoskr.lastpos.y / TILE_SIZE 
        if stage % 2 ~= 0 then
            if maze_position_y == 1 then
                gameState = INTERMISSION
            end
        else
            if maze_position_y == TREE_HEIGHT then
                gameState = INTERMISSION
            end
        end
    end
end

function ratatoskr:draw()
    if ratatoskr.state == DEAD then 
        love.graphics.setColor(1, 0.5, 0.5)
        ratatoskr_run_animation:draw(ratatoskr_image, self.x + TILE_SIZE / 2 + TILE_SIZE, self.y - TILE_SIZE / 2, ratatoskr.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)    
    elseif ratatoskr.state ~= WAITING then
        love.graphics.setColor(1, 1, 1)
        ratatoskr_run_animation:draw(ratatoskr_image, self.x + TILE_SIZE / 2 + TILE_SIZE, self.y - TILE_SIZE / 2, ratatoskr.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)    
    elseif ratatoskr.state == WAITING then
        love.graphics.setColor(1, 1, 1)
        ratatoskr_idle_animation:draw(ratatoskr_image, self.x + TILE_SIZE / 2 + TILE_SIZE, self.y - TILE_SIZE / 2, ratatoskr.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)      
    end
end