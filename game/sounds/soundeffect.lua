local soundeffect = {}

soundeffect.effects = {}   
soundeffect.volume = 0.5     
soundeffect.playing = {}     

function soundeffect:load(path)
    if not self.effects[path] then
        self.effects[path] = love.audio.newSource(path, "static")
    end
    return self.effects[path]:clone() 
end


function soundeffect:play(path)
    local sound = self:load(path)
    sound:setVolume(self.volume)
    sound:play()

    table.insert(self.playing, sound)
end


function soundeffect:update()
    for i = #self.playing, 1, -1 do
        if not self.playing[i]:isPlaying() then
            table.remove(self.playing, i)
        end
    end
end


function soundeffect:setVolume(v)
    self.volume = math.max(0, math.min(1, v))
end


function soundeffect:stopAll()
    for _, source in ipairs(self.playing) do
        source:stop()
    end
    self.playing = {}
end

return soundeffect
