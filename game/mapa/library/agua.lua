local Agua = {}
Agua.__index = Agua

function Agua.new(x, y, cor)
    local self = setmetatable({}, Agua)
    self.x = x
    self.y = y
    self.cor = cor
    self.width = 16
    self.height = 16
    return self
end

function Agua:draw()
    local px = self.x
    local py = self.y
    love.graphics.setColor(self.cor[1], self.cor[2], self.cor[3])
    love.graphics.rectangle("fill", px, py, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

return Agua