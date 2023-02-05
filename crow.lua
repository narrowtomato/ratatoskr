crows = {}

function update_crows(dt)
    for k,crow in pairs(crows) do 
        -- Wait for the player to reach the crow's level then fly at them
        if crow.state == WAITING then
            if crow.x < 100 then 
                crow.facing = -1
            else
                crow.facing = 1
            end
            if ratatoskr.y == crow.y then
                if ratatoskr.x < crow.x then
                    crow.state = MOVING_WEST
                else
                    crow.state = MOVING_EAST
                end
            end
        -- Fly to the other side of the tree and reset
        elseif crow.state == MOVING_EAST then
            crow.facing = -1
            crow.x = crow.x + crow.speed * dt
            if crow.x > (TREE_WIDTH) * TILE_SIZE then
                crow.x = (TREE_WIDTH) * TILE_SIZE
                crow.state = WAITING
            end
        elseif crow.state == MOVING_WEST then
            crow.facing = 1
            crow.x = crow.x - crow.speed * dt
            if crow.x < 0 - TILE_SIZE then
                crow.x = 0 - TILE_SIZE
                crow.state = WAITING
            end
        end
    end
end

function draw_crows()
    love.graphics.setColor(0, 1, 1)
    for k,crow in pairs(crows) do
        love.graphics.rectangle("fill", crow.x + (TILE_SIZE / 4) + TILE_SIZE, crow.y - (TILE_SIZE / 4 * 3), TILE_SIZE / 2, TILE_SIZE / 2)
    
        if crow.state == WAITING then
            crow_idle_animation:draw(crow_image, crow.x + TILE_SIZE / 2 + TILE_SIZE, crow.y - TILE_SIZE / 2, nil, crow.facing, 1, TILE_SIZE / 2, TILE_SIZE / 2)
        else
            crow_fly_animation:draw(crow_image, crow.x + TILE_SIZE / 2 + TILE_SIZE, crow.y - TILE_SIZE / 2, nil, crow.facing, 1, TILE_SIZE / 2, TILE_SIZE / 2)
        end
    end
end

function spawn_crows(number, mov_speed)
    for i=1, number, 1 do 
        local crow = {
            x = love.math.random(0, 1) * (TREE_WIDTH + 1) * TILE_SIZE - TILE_SIZE,
            y = love.math.random(3, TREE_HEIGHT - 3) * TILE_SIZE,
            radius = 10,
            speed = mov_speed,
            state = WAITING,
            facing = 1
        }
        table.insert(crows, crow)
    end
end

function destroy_all_crows()
    for i=#crows, 1, -1 do
        table.remove(crows, i)
    end
end