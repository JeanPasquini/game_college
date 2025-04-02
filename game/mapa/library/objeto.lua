local Objeto = {}
Objeto.__index = Objeto
function Objeto.new(x, y, valorImagem)
    local self = setmetatable({}, Objeto)
    self.x = x
    self.y = y
    self.valorImagem = valorImagem

    -- Lógica para escolher a imagem com base no valor passado
    if valorImagem == 1 then
        self.imagem = love.graphics.newImage("resources/tiles/grama.png")  -- Caminho para a imagem de grama
    elseif valorImagem == 2 then
        self.imagem = love.graphics.newImage("resources/tiles/terra.png")  -- Caminho para a imagem de terra
    else
        self.imagem = nil  -- Caso não seja 1 ou 2, a imagem é definida como nil
        print("Valor inválido para imagem:", valorImagem)
    end

    -- Se a imagem foi carregada corretamente
    if self.imagem then
        self.width = self.imagem:getWidth()
        self.height = self.imagem:getHeight()
    end

    self.visible = true  -- Define a propriedade visible
    return self
end

function Objeto:draw()
    if self.visible then  -- Verifica se o objeto está visível antes de desenhá-lo
        local px = self.x
        local py = self.y
        love.graphics.setColor(1, 1, 1)  -- Reseta a cor para branco (sem cor alterada)
        love.graphics.draw(self.imagem, px, py)  -- Desenha a imagem
    end
end

return Objeto
