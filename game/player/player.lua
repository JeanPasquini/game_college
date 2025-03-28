Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x = x or 0
    self.y = y or 0
    self.speed = 5
    self.visible = true
    self.velocidadeY = 0
    self.gravidade = 0.5
    return self
end

function Player:update()
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed
    end

    self.velocidadeY = self.velocidadeY + self.gravidade
    self.y = self.y + self.velocidadeY
end

function Player:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, 32, 32)
    love.graphics.setColor(1, 1, 1)
end

return Player
