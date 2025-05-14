local ObjetoCenario = {}
ObjetoCenario.__index = ObjetoCenario

function ObjetoCenario.new(x, y, valorImagem)
    local self = setmetatable({}, ObjetoCenario)
    self.x = x
    self.y = y
    self.tipo = 3
    self.valorImagem = valorImagem
    self.conectado = nil 

    if valorImagem == 6 then
        self.imagem = love.graphics.newImage("resources/tiles/6.png")
    elseif valorImagem == 20 then
        self.imagem = love.graphics.newImage("resources/tiles/20.png")
    elseif valorImagem == 21 then
        self.imagem = love.graphics.newImage("resources/tiles/21.png")
    elseif valorImagem == 22 then
        self.imagem = love.graphics.newImage("resources/tiles/22.png")
    elseif valorImagem == 23 then
        self.imagem = love.graphics.newImage("resources/tiles/23.png")
    else
        self.imagem = nil
        print("Valor inválido para imagem:", valorImagem)
    end

    if self.imagem then
        self.width = self.imagem:getWidth()
        self.height = self.imagem:getHeight()
    end

    self.visible = true
    return self
end

function ObjetoCenario:setConexao(objeto)
    self.conectado = objeto
end

function ObjetoCenario:atualizarConexao()
    if self.conectado then
        self.conectado.x = self.x
        self.conectado.y = self.y - config.tamanhoQuadrado
    end
end


function ObjetoCenario:draw()
    if self.visible then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.imagem, self.x, self.y)
    end
end

return ObjetoCenario
