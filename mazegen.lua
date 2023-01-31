function mazegen(width, height)
    -- Construct a table to represent the maze
    -- Each cell is represented by a binary value of initially decimal 15 (1111) for 4 walls
    local maze = {}
    for i=1, height, 1 do
        local row = {}
        for j=1, width, 1 do
            table.insert(row, 15)
        end
        table.insert(maze, row)
    end

    -- Robot that will carve out the maze
    local robot = {}
    -- Coordinates of the robot's current position, initially set to a random y and x value
    robot.x = love.math.random(1, width)
    robot.y = love.math.random(1, height)
    -- Table of coordinates representing visited cells (to append to and verify when maze is complete)
    robot.visited = {{x=robot.x, y=robot.y}}
    -- Table representing visited cells that are forkable (to append and pop from to go back when the robot cannot find an unvisited cell)
    robot.visited_forkable = {}

    count = 0
    -- Loop to carve out the maze
    while #robot.visited < width * height do

        -- List of possible directions the robot can move
        local available_directions = {}

        -- Add possible directions based on conditions
        -- print(robot.x, robot.y)
        -- print(tprint(robot.visited))
        if (robot.x > 1) and not hasPoint(robot.visited, robot.x - 1, robot.y) then
            table.insert(available_directions, "left")
        end
        if (robot.x < width) and not hasPoint(robot.visited, robot.x + 1, robot.y) then
            table.insert(available_directions, "right")
        end
        if (robot.y > 1) and not hasPoint(robot.visited, robot.x, robot.y - 1) then
            table.insert(available_directions, "up")
        end
        if (robot.y < height) and not hasPoint(robot.visited, robot.x, robot.y + 1) then
            table.insert(available_directions, "down")
        end

        -- If no directions were possible, revert to the previous value in robot.visited_forkable
        --   and restart the loop
        if #available_directions == 0 then
            table.remove(robot.visited_forkable)
            robot.x = robot.visited_forkable[#robot.visited_forkable].x
            robot.y = robot.visited_forkable[#robot.visited_forkable].y
        else

            -- Choose a direction to move
            local choice = available_directions[love.math.random(1, #available_directions)]

            -- Update the walls of the current cell, move the robot, and update the walls of the new cell all based on the direction of movement
            if choice == "left" then
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 1
                robot.x = robot.x - 1
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 4
            elseif choice == "right" then
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 4
                robot.x = robot.x + 1
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 1
            elseif choice == "up" then
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 8
                robot.y = robot.y - 1
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 2
            elseif choice == "down" then
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 2
                robot.y = robot.y + 1
                maze[robot.y][robot.x] = maze[robot.y][robot.x] - 8
            end

            -- Add the new cell to the lists of visited cells
            table.insert(robot.visited, {x=robot.x, y=robot.y})
            table.insert(robot.visited_forkable, {x=robot.x, y=robot.y})
        end
    end

    print(tprint(robot.visited))

    return maze
end

-- Function to find if a table has (x, y ) point
function hasPoint(table, x, y)
    for k,v in pairs(table) do
        if v.x == x and v.y == y then 
            return true
        end
    end
    return false
end