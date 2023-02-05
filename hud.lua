hud = {}

hud.energy_bar = {}

function hud:update()

end

function hud:draw()
    -- Stage and Lives
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Stage: " .. stage .. "    Lives: " .. lives)

    -- Energy Bar
    love.graphics.setColor(250 / ratatoskr.energy, ratatoskr.energy / ratatoskr.MAX_ENERGY, 0)
    love.graphics.rectangle("fill", 0, gameHeight - TILE_SIZE, ratatoskr.energy / ratatoskr.MAX_ENERGY * gameWidth, TILE_SIZE)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, gameHeight - TILE_SIZE, gameWidth, TILE_SIZE)
end