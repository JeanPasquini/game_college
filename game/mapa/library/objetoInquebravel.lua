local ObjetoInquebravel = {}
ObjetoInquebravel.__index = ObjetoInquebravel
function ObjetoInquebravel.new(x, y, valorImagem)
    local self = setmetatable({}, ObjetoInquebravel)
    self.x = x
    self.y = y
    self.tipo = 2
    self.valorImagem = valorImagem

    if valorImagem == 32 then
        self.imagem = love.graphics.newImage("resources/tiles/32.png")
    elseif valorImagem == 33 then
        self.imagem = love.graphics.newImage("resources/tiles/33.png")  
    elseif valorImagem == 34 then
        self.imagem = love.graphics.newImage("resources/tiles/34.png")  
    elseif valorImagem == 35 then
        self.imagem = love.graphics.newImage("resources/tiles/35.png")  
    elseif valorImagem == 36 then
        self.imagem = love.graphics.newImage("resources/tiles/36.png")  
    elseif valorImagem == 37 then
        self.imagem = love.graphics.newImage("resources/tiles/37.png")  
    elseif valorImagem == 38 then
        self.imagem = love.graphics.newImage("resources/tiles/38.png")  
    elseif valorImagem == 39 then
        self.imagem = love.graphics.newImage("resources/tiles/39.png")  
    elseif valorImagem == 40 then
        self.imagem = love.graphics.newImage("resources/tiles/40.png")  
    elseif valorImagem == 41 then
        self.imagem = love.graphics.newImage("resources/tiles/41.png")  
    elseif valorImagem == 42 then
        self.imagem = love.graphics.newImage("resources/tiles/42.png")  
    elseif valorImagem == 43 then
        self.imagem = love.graphics.newImage("resources/tiles/43.png")  
    elseif valorImagem == 44 then
        self.imagem = love.graphics.newImage("resources/tiles/44.png")  
    elseif valorImagem == 45 then
        self.imagem = love.graphics.newImage("resources/tiles/45.png")  
    elseif valorImagem == 46 then
        self.imagem = love.graphics.newImage("resources/tiles/46.png")  
    elseif valorImagem == 47 then
        self.imagem = love.graphics.newImage("resources/tiles/47.png")  
    elseif valorImagem == 48 then
        self.imagem = love.graphics.newImage("resources/tiles/48.png")  
    elseif valorImagem == 49 then
        self.imagem = love.graphics.newImage("resources/tiles/49.png")  
    elseif valorImagem == 50 then
        self.imagem = love.graphics.newImage("resources/tiles/50.png")  
    elseif valorImagem == 51 then
        self.imagem = love.graphics.newImage("resources/tiles/51.png")  
    elseif valorImagem == 52 then
        self.imagem = love.graphics.newImage("resources/tiles/52.png")  
        
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

function ObjetoInquebravel:draw()
    if self.visible then
        local px = self.x
        local py = self.y
        love.graphics.setColor(1, 1, 1) 
        love.graphics.draw(self.imagem, px, py) 
    end
end

return ObjetoInquebravel
