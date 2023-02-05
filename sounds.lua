sounds = {}

-- Music
sounds.music1 = love.audio.newSource("sound/song1v3.wav", "stream")
sounds.music1:setVolume(0.7)
sounds.music2 = love.audio.newSource("sound/song2v2.wav", "stream")
sounds.music2:setVolume(0.7)

-- Effects
sounds.hurt = love.audio.newSource("sound/squirrel_hurt1.wav", "static")
sounds.jump =  love.audio.newSource("sound/squirrel_jump1v2.wav", "static")
sounds.walk = love.audio.newSource("sound/squirrel_walk1.wav", "static")
sounds.crow = love.audio.newSource("sound/screech1.wav", "static")

