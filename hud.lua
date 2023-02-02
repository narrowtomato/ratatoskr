hud = {}

hud.energy_bar = {}

function hud:update()

end

function hud:draw()
    love.graphics.setColor(500 / ratatoskr.energy, ratatoskr.energy / ratatoskr.MAX_ENERGY, 0)
    love.graphics.rectangle("fill", 0, gameHeight - TILE_SIZE, ratatoskr.energy / ratatoskr.MAX_ENERGY * gameWidth, TILE_SIZE)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, gameHeight - TILE_SIZE, gameWidth, TILE_SIZE)
end