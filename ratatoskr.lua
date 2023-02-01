ratatoskr = {}

ratatoskr.ENERGY_GAIN_RATE = 500
ratatoskr.MAX_ENERGY = 1000
ratatoskr.JUMP_DEPLETE = 500

ratatoskr.x = math.floor(TREE_WIDTH / 2) * TILE_SIZE
ratatoskr.y = TREE_HEIGHT * TILE_SIZE
ratatoskr.speed = 20
ratatoskr.state = WAITING
ratatoskr.lastpos = {x=ratatoskr.x,y=ratatoskr.y}
ratatoskr.nextpos = {x=ratatoskr.x,y=ratatoskr.y}
ratatoskr.energy = ratatoskr.MAX_ENERGY



function ratatoskr:update(dt)
    -- ratatoskr movement
    if ratatoskr.state == MOVING_NORTH then
        ratatoskr.y = ratatoskr.y - ratatoskr.speed * dt
        if ratatoskr.y <= ratatoskr.nextpos.y then
            ratatoskr.y = ratatoskr.nextpos.y
            ratatoskr.lastpos.y = ratatoskr.y
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_SOUTH then
        ratatoskr.y = ratatoskr.y + ratatoskr.speed * dt
        if ratatoskr.y >= ratatoskr.nextpos.y then
            ratatoskr.y = ratatoskr.nextpos.y
            ratatoskr.lastpos.y = ratatoskr.y
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_EAST then
        ratatoskr.x = ratatoskr.x + ratatoskr.speed * dt
        if ratatoskr.x >= ratatoskr.nextpos.x then
            ratatoskr.x = ratatoskr.nextpos.x
            ratatoskr.lastpos.x = ratatoskr.x
            ratatoskr.state = WAITING
        end
    elseif ratatoskr.state == MOVING_WEST then
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
end

function ratatoskr:draw()
    love.graphics.setColor(255/255, 204/255, 0/255)
    love.graphics.rectangle("fill", self.x + (TILE_SIZE / 4) + TILE_SIZE, self.y - (TILE_SIZE / 4 * 3), TILE_SIZE / 2, TILE_SIZE / 2)
end