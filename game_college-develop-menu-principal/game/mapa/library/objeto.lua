local Objeto = {}
Objeto.__index = Objeto

function Objeto.new(x, y, cor)
    local self = setmetatable({}, Objeto)
    self.x = x
    self.y = y
    self.cor = cor
    self.width = 16
    self.height = 16
    self.visible = true  -- Define a propriedade visible
    return self
end

function Objeto:draw()
    if self.visible then  -- Verifica se o objeto está visível antes de desenhá-lo
        local px = self.x
        local py = self.y
        love.graphics.setColor(self.cor[1], self.cor[2], self.cor[3])
        love.graphics.rectangle("fill", px, py, self.width, self.height)
    end
end

return Objeto
