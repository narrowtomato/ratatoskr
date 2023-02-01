beetles = {}

function update_beetles(dt)
    for k,beetle in pairs(beetles) do
        if beetle.state == WAITING then
            if canMoveDirection(beetle, "up") and beetle.attempting_direction == "up" then
                beetle.state = MOVING_NORTH
                beetle.nextpos.x = beetle.lastpos.x
                beetle.nextpos.y = beetle.lastpos.y - TILE_SIZE
            elseif canMoveDirection(beetle, "left") and beetle.attempting_direction == "left" then
                beetle.state = MOVING_WEST
                beetle.nextpos.x = beetle.lastpos.x - TILE_SIZE
                beetle.nextpos.y = beetle.lastpos.y
            elseif canMoveDirection(beetle, "down") and beetle.attempting_direction == "down" then
                beetle.state = MOVING_SOUTH
                beetle.nextpos.x = beetle.lastpos.x
                beetle.nextpos.y = beetle.lastpos.y + TILE_SIZE
            elseif canMoveDirection(beetle, "right") and beetle.attempting_direction == "right" then
                beetle.state = MOVING_EAST
                beetle.nextpos.x = beetle.lastpos.x + TILE_SIZE
                beetle.nextpos.y = beetle.lastpos.y
            else
                if beetle.attempting_direction == "up" then beetle.attempting_direction = "left" 
                elseif beetle.attempting_direction == "left" then beetle.attempting_direction = "down"
                elseif beetle.attempting_direction == "down" then beetle.attempting_direction = "right"
                elseif beetle.attempting_direction == "right" then beetle.attempting_direction = "up" 
                end
            end
        elseif beetle.state == MOVING_NORTH then
            beetle.y = beetle.y - beetle.speed * dt
            if beetle.y <= beetle.nextpos.y then
                beetle.y = beetle.nextpos.y
                beetle.lastpos.y = beetle.y
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_SOUTH then
            beetle.y = beetle.y + beetle.speed * dt
            if beetle.y >= beetle.nextpos.y then
                beetle.y = beetle.nextpos.y
                beetle.lastpos.y = beetle.y
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_EAST then
            beetle.x = beetle.x + beetle.speed * dt
            if beetle.x >= beetle.nextpos.x then
                beetle.x = beetle.nextpos.x
                beetle.lastpos.x = beetle.x
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_WEST then
            beetle.x = beetle.x - beetle.speed * dt
            if beetle.x <= beetle.nextpos.x then
                beetle.x = beetle.nextpos.x
                beetle.lastpos.x = beetle.x
                beetle.state = WAITING
            end
        end
    end
end

function draw_beetles()
    love.graphics.setColor(252/255, 10/255, 216/255)
    for k,beetle in pairs(beetles) do
        love.graphics.rectangle("fill", beetle.x + (TILE_SIZE / 4) + TILE_SIZE, beetle.y - (TILE_SIZE / 4 * 3), TILE_SIZE / 2, TILE_SIZE / 2)
    end
end

function spawn_beetles(number)
    for i=1, number, 1 do 
        local beetle = {
            x = love.math.random(1, TREE_WIDTH - 1) * TILE_SIZE,
            y = love.math.random(1, TREE_HEIGHT) * TILE_SIZE,
            speed = 5,
            state = WAITING,
            nextpos = {x=x,y=y},
            attempting_direction = "up"
        }
        beetle.lastpos = {x=beetle.x, y=beetle.y}
        table.insert(beetles, beetle)
    end
end