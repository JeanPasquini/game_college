local soundtrack = {}

soundtrack.currentMusic = nil
soundtrack.currentPath = nil
soundtrack.targetPath = nil
soundtrack.volume = 0.5
soundtrack.currentVolume = 0 
soundtrack.fadeSpeed = 1 
soundtrack.state = "idle" 

function soundtrack:play(path, loop)
    self:stop()
    self.currentMusic = love.audio.newSource(path, "stream")

    if loop == nil then loop = true end

    self.currentMusic:setLooping(loop)
    self.currentMusic:setVolume(0)
    self.currentMusic:play()

    self.currentVolume = 0
    self.state = "fading_in"
end

function soundtrack:stop()
    if self.currentMusic and self.currentMusic:isPlaying() then
        self.currentMusic:stop()
    end
end

function soundtrack:update(dt)
    if self.state == "fading_out" then
        self.currentVolume = self.currentVolume - dt / self.fadeSpeed
        if self.currentVolume <= 0 then
            self.currentVolume = 0
            self:stop()
            self:play(self.targetPath)
        elseif self.currentMusic then
            self.currentMusic:setVolume(self.currentVolume)
        end

    elseif self.state == "fading_in" then
        self.currentVolume = self.currentVolume + dt / self.fadeSpeed
        if self.currentVolume >= self.volume then
            self.currentVolume = self.volume
            self.state = "idle"
        end
        if self.currentMusic then
            self.currentMusic:setVolume(self.currentVolume)
        end
    end
end

function soundtrack:changeMusicGradually(path, loop)
    if self.currentPath == path or self.state == "fading_out" then return end

    self.targetPath = path
    self.state = "fading_out"
    self.currentPath = path
end

function soundtrack:setVolume(vol)
    self.volume = vol
    self.currentVolume = vol
    self.state = "idle"
    if self.currentMusic then
        self.currentMusic:setVolume(vol)
    end
end

return soundtrack
