local Agua = {}
Agua.__index = Agua

function Agua.new(x, y, valorImagem)
    local self = setmetatable({}, Agua)
    self.x = x
    self.y = y - 3
    self.visible = true
    self.valorImagem = valorImagem

    if valorImagem == 30 then
        self.imagem = love.graphics.newImage("resources/tiles/30.png")  
    elseif valorImagem == 31 then 
        self.imagens = {
            love.graphics.newImage("resources/sprites/water/agua1.png"),
            love.graphics.newImage("resources/sprites/water/agua2.png")
        }
        self.frameAtual = 1
        self.tempoTroca = 0.5
        self.temporizador = 0
        self.imagem = self.imagens[self.frameAtual]
    end

    if self.imagem then
        self.width = self.imagem:getWidth()
        self.height = self.imagem:getHeight()
    else
        self.width = 32 
        self.height = 32
    end

    return self
end

function Agua:update(dt)
    if self.valorImagem == 31 then
        self.temporizador = self.temporizador + dt
        if self.temporizador >= self.tempoTroca then
            self.temporizador = 0
            self.frameAtual = self.frameAtual % #self.imagens + 1
            self.imagem = self.imagens[self.frameAtual]
        end
    end
end

function Agua:draw()
    if self.visible and self.imagem then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.imagem, self.x, self.y)
    end
end

return Agua
