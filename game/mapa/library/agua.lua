local Agua = {}
Agua.__index = Agua

function Agua.new(x, y)
    local self = setmetatable({}, Agua)
    self.x = x
    self.y = y - 3
    self.visible = true

    -- Sprites de animação
    self.imagens = {
        love.graphics.newImage("resources/sprites/water/agua1.png"),
        love.graphics.newImage("resources/sprites/water/agua2.png")
    }

    self.frameAtual = 1
    self.tempoTroca = 0.5
    self.temporizador = 0

    self.imagem = self.imagens[self.frameAtual]

    if self.imagem then
        self.width = self.imagem:getWidth()
        self.height = self.imagem:getHeight()
    end

    return self
end

function Agua:update(dt)
    self.temporizador = self.temporizador + dt
    if self.temporizador >= self.tempoTroca then
        self.temporizador = 0
        self.frameAtual = self.frameAtual % #self.imagens + 1
        self.imagem = self.imagens[self.frameAtual]
    end
end

function Agua:draw()
    if self.visible then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.imagem, self.x, self.y)
    end
end

return Agua
