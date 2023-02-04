crows = {}

function update_crows(dt)
    for k,crow in pairs(crows) do 
        -- Wait for the player to reach the crow's level then fly at them
        if crow.state == WAITING then
            if ratatoskr.y == crow.y then
                if ratatoskr.x < crow.x then
                    crow.state = MOVING_WEST
                else
                    crow.state = MOVING_EAST
                end
            end
        -- Fly to the other side of the tree and reset
        elseif crow.state == MOVING_EAST then
            crow.x = crow.x + crow.speed * dt
            if crow.x > (TREE_WIDTH) * TILE_SIZE then
                crow.x = (TREE_WIDTH) * TILE_SIZE
                crow.state = WAITING
            end
        elseif crow.state == MOVING_WEST then
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
    end
end

function spawn_crows(number, mov_speed)
    for i=1, number, 1 do 
        local crow = {
            x = love.math.random(0, 1) * (TREE_WIDTH + 1) * TILE_SIZE - TILE_SIZE,
            y = love.math.random(3, TREE_HEIGHT - 3) * TILE_SIZE,
            radius = 10,
            speed = mov_speed,
            state = WAITING
        }
        table.insert(crows, crow)
    end
end

function destroy_all_crows()
    for i=#crows, 1, -1 do
        table.remove(crows, i)
    end
end