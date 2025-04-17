local Objeto = {}
Objeto.__index = Objeto
function Objeto.new(x, y, valorImagem)
    local self = setmetatable({}, Objeto)
    self.x = x
    self.y = y
    self.valorImagem = valorImagem

    -- Lógica para escolher a imagem com base no valor passado
    if valorImagem == 1 then
        self.imagem = love.graphics.newImage("resources/tiles/1.png")  -- Caminho para a imagem de grama
    elseif valorImagem == 2 then
        self.imagem = love.graphics.newImage("resources/tiles/2.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 3 then
        self.imagem = love.graphics.newImage("resources/tiles/3.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 4 then
        self.imagem = love.graphics.newImage("resources/tiles/4.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 5 then
        self.imagem = love.graphics.newImage("resources/tiles/5.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 6 then
        self.imagem = love.graphics.newImage("resources/tiles/6.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 7 then
        self.imagem = love.graphics.newImage("resources/tiles/7.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 8 then
        self.imagem = love.graphics.newImage("resources/tiles/8.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 9 then
        self.imagem = love.graphics.newImage("resources/tiles/9.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 10 then
        self.imagem = love.graphics.newImage("resources/tiles/10.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 11 then
        self.imagem = love.graphics.newImage("resources/tiles/11.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 12 then
        self.imagem = love.graphics.newImage("resources/tiles/12.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 13 then
        self.imagem = love.graphics.newImage("resources/tiles/13.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 14 then
        self.imagem = love.graphics.newImage("resources/tiles/14.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 15 then
        self.imagem = love.graphics.newImage("resources/tiles/15.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 16 then
        self.imagem = love.graphics.newImage("resources/tiles/16.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 17 then
        self.imagem = love.graphics.newImage("resources/tiles/17.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 18 then
        self.imagem = love.graphics.newImage("resources/tiles/18.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 19 then
        self.imagem = love.graphics.newImage("resources/tiles/19.png")  -- Caminho para a imagem de terra
    elseif valorImagem == 30 then
        self.imagem = love.graphics.newImage("resources/tiles/30.png")  -- Caminho para a imagem de terra
        self.y = self.y - 3

        
        
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
