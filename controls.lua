function getKeyboardInput()
    if ratatoskr.state == WAITING then
        -- Initiating movement across branches
        if love.keyboard.isDown('up') or (joystick and joystick:isGamepadDown("dpup")) and canMoveDirection(ratatoskr, "up") then
            ratatoskr.state = MOVING_NORTH
            ratatoskr.nextpos.x = ratatoskr.lastpos.x
            ratatoskr.nextpos.y = ratatoskr.lastpos.y - TILE_SIZE
        elseif love.keyboard.isDown('left') or (joystick and joystick:isGamepadDown("dpleft")) and canMoveDirection(ratatoskr, "left") then
            ratatoskr.state = MOVING_WEST
            ratatoskr.nextpos.x = ratatoskr.lastpos.x - TILE_SIZE
            ratatoskr.nextpos.y = ratatoskr.lastpos.y
        elseif love.keyboard.isDown('down') or (joystick and joystick:isGamepadDown("dpdown")) and canMoveDirection(ratatoskr, "down") then
            ratatoskr.state = MOVING_SOUTH
            ratatoskr.nextpos.x = ratatoskr.lastpos.x
            ratatoskr.nextpos.y = ratatoskr.lastpos.y + TILE_SIZE
        elseif love.keyboard.isDown('right') or (joystick and joystick:isGamepadDown("dpright")) and canMoveDirection(ratatoskr, "right") then
            ratatoskr.state = MOVING_EAST
            ratatoskr.nextpos.x = ratatoskr.lastpos.x + TILE_SIZE
            ratatoskr.nextpos.y = ratatoskr.lastpos.y
        end
        
        -- Jumping across gaps
        if love.keyboard.isDown('space') or (joystick and joystick:isGamepadDown("a")) and ratatoskr.energy > ratatoskr.JUMP_DEPLETE then 
            
            -- Get the maze position to determine if on edge
            local maze_position = {}
            maze_position.x = ratatoskr.lastpos.x / TILE_SIZE + 1
            maze_position.y = ratatoskr.lastpos.y / TILE_SIZE 
            
            if love.keyboard.isDown('up') or (joystick and joystick:isGamepadDown("dpup")) and maze_position.y > 1 then
                ratatoskr.state = MOVING_NORTH
                ratatoskr.nextpos.x = ratatoskr.lastpos.x
                ratatoskr.nextpos.y = ratatoskr.lastpos.y - TILE_SIZE
                ratatoskr.energy = ratatoskr.energy - ratatoskr.JUMP_DEPLETE
            elseif love.keyboard.isDown('left') or (joystick and joystick:isGamepadDown("dpleft")) and maze_position.x > 1 then
                ratatoskr.state = MOVING_WEST
                ratatoskr.nextpos.x = ratatoskr.lastpos.x - TILE_SIZE
                ratatoskr.nextpos.y = ratatoskr.lastpos.y
                ratatoskr.energy = ratatoskr.energy - ratatoskr.JUMP_DEPLETE
            elseif love.keyboard.isDown('down') or (joystick and joystick:isGamepadDown("dpdown")) and maze_position.y < TREE_HEIGHT then
                ratatoskr.state = MOVING_SOUTH
                ratatoskr.nextpos.x = ratatoskr.lastpos.x
                ratatoskr.nextpos.y = ratatoskr.lastpos.y + TILE_SIZE
                ratatoskr.energy = ratatoskr.energy - ratatoskr.JUMP_DEPLETE
            elseif love.keyboard.isDown('right') or (joystick and joystick:isGamepadDown("dpright")) and maze_position.x < TREE_WIDTH then
                ratatoskr.state = MOVING_EAST
                ratatoskr.nextpos.x = ratatoskr.lastpos.x + TILE_SIZE
                ratatoskr.nextpos.y = ratatoskr.lastpos.y
                ratatoskr.energy = ratatoskr.energy - ratatoskr.JUMP_DEPLETE
            end
        end
    end
end

-- Function to determine if an entity is able to move in a direction
function canMoveDirection(entity, direction)
    -- Get the maze position of the entity
    local maze_position = {}
    maze_position.x = entity.lastpos.x / TILE_SIZE + 1
    maze_position.y = entity.lastpos.y / TILE_SIZE 

    -- Get the tile value of the maze position
    local tile_value = yggdrasil.map[maze_position.y][maze_position.x]

    -- Determine if movement can happen based on direction
    if tile_value == 0 then
        return true
    elseif tile_value == 1 then
        if direction == "up" or direction == "right" or direction == "down" then return true end
    elseif tile_value == 2 then
        if direction == "up" or direction == "right" or direction == "left" then return true end
    elseif tile_value == 3 then
        if direction == "up" or direction == "right" then return true end
    elseif tile_value == 4 then
        if direction == "up" or direction == "down" or direction == "left" then return true end
    elseif tile_value == 5 then
        if direction == "up" or direction == "down" then return true end
    elseif tile_value == 6 then
        if direction == "up" or direction == "left" then return true end
    elseif tile_value == 7 then
        if direction == "up" then return true end
    elseif tile_value == 8 then
        if direction == "right" or direction == "down" or direction == "left" then return true end
    elseif tile_value == 9 then
        if direction == "right" or direction == "down" then return true end
    elseif tile_value == 10 then
        if direction == "right" or direction == "left" then return true end
    elseif tile_value == 11 then
        if direction == "right" then return true end
    elseif tile_value == 12 then
        if direction == "down" or direction == "left" then return true end
    elseif tile_value == 13 then
        if direction == "down" then return true end
    elseif tile_value == 14 then
        if direction == "left" then return true end
    end
    return false
end