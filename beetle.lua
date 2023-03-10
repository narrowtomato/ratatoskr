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
                local dirs = {"up", "down", "left", "right"}
                beetle.attempting_direction = dirs[love.math.random(1, 4)]
            end
        elseif beetle.state == MOVING_NORTH then
            beetle.angle = 0
            beetle.y = beetle.y - beetle.speed * dt
            if beetle.y <= beetle.nextpos.y then
                beetle.y = beetle.nextpos.y
                beetle.lastpos.y = beetle.y
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_SOUTH then
            beetle.angle = math.pi
            beetle.y = beetle.y + beetle.speed * dt
            if beetle.y >= beetle.nextpos.y then
                beetle.y = beetle.nextpos.y
                beetle.lastpos.y = beetle.y
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_EAST then
            beetle.angle = math.pi / 2
            beetle.x = beetle.x + beetle.speed * dt
            if beetle.x >= beetle.nextpos.x then
                beetle.x = beetle.nextpos.x
                beetle.lastpos.x = beetle.x
                beetle.state = WAITING
            end
        elseif beetle.state == MOVING_WEST then
            beetle.angle = 3 * math.pi / 2
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
    love.graphics.setColor(1, 1, 1)
    for k,beetle in pairs(beetles) do
        if beetle.color_variant == 1 then
            beetle_1_animation:draw(beetle_image_1, beetle.x + TILE_SIZE / 2 + TILE_SIZE, beetle.y - TILE_SIZE / 2, beetle.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
        elseif beetle.color_variant == 2 then
            beetle_2_animation:draw(beetle_image_2, beetle.x + TILE_SIZE / 2 + TILE_SIZE, beetle.y - TILE_SIZE / 2, beetle.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
        elseif beetle.color_variant == 3 then
            beetle_3_animation:draw(beetle_image_3, beetle.x + TILE_SIZE / 2 + TILE_SIZE, beetle.y - TILE_SIZE / 2, beetle.angle, nil, nil, TILE_SIZE / 2, TILE_SIZE / 2)
        end
    end
end

function spawn_beetles(number, mov_speed)
    for i=1, number, 1 do 
        local beetle = {
            x = love.math.random(1, TREE_WIDTH - 1) * TILE_SIZE,
            y = love.math.random(3, TREE_HEIGHT - 3) * TILE_SIZE,
            radius = 10,
            speed = mov_speed,
            state = WAITING,
            nextpos = {x=x,y=y},
            attempting_direction = "up",
            color_variant = love.math.random(1, 3),
            angle = 0
        }
        beetle.lastpos = {x=beetle.x, y=beetle.y}
        table.insert(beetles, beetle)
    end
end

function destroy_all_beetles()
    for i=#beetles, 1, -1 do
        table.remove(beetles, i)
    end
end