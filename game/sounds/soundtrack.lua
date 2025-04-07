local soundtrack = {}

soundtrack.currentMusic = nil
soundtrack.currentPath = nil
soundtrack.targetPath = nil
soundtrack.volume = 0.2
soundtrack.fadeSpeed = 1 -- segundos
soundtrack.state = "idle" -- pode ser: "idle", "fading_out", "fading_in"

function soundtrack:play(path, loop)
    self:stop()
    self.currentMusic = love.audio.newSource(path, "stream")

    -- Se o parâmetro loop for nil, assume true como padrão
    if loop == nil then loop = true end

    self.currentMusic:setLooping(loop)
    self.currentMusic:setVolume(0)
    self.currentMusic:play()

    self.volume = 0
    self.state = "fading_in"
end


function soundtrack:stop()
    if self.currentMusic and self.currentMusic:isPlaying() then
        self.currentMusic:stop()
    end
end

function soundtrack:update(dt)
    if self.state == "fading_out" then
        self.volume = self.volume - dt / self.fadeSpeed
        if self.volume <= 0 then
            self.volume = 0
            self:stop()
            self:play(self.targetPath)
        else
            self.currentMusic:setVolume(self.volume)
        end

    elseif self.state == "fading_in" then
        self.volume = self.volume + dt / self.fadeSpeed
        if self.volume >= 1 then
            self.volume = 1
            self.state = "idle"
        end
        if self.currentMusic then
            self.currentMusic:setVolume(self.volume)
        end
    end
end

function soundtrack:changeMusicGradually(path, loop)
    if self.currentPath == path or self.state == "fading_out" then return end

    self.targetPath = path
    --self.targetLoop = loop ~= false  -- se for nil ou true, será true. Se for false, será false.
    self.state = "fading_out"
    self.currentPath = path
end

return soundtrack
