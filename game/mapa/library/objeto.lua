local Objeto = {}
Objeto.__index = Objeto
function Objeto.new(x, y, valorImagem)
    local self = setmetatable({}, Objeto)
    self.x = x
    self.y = y
    self.tipo = 1
    self.valorImagem = valorImagem

    if valorImagem == 1 then
        self.imagem = love.graphics.newImage("resources/tiles/1.png")  
    elseif valorImagem == 2 then
        self.imagem = love.graphics.newImage("resources/tiles/2.png")  
    elseif valorImagem == 3 then
        self.imagem = love.graphics.newImage("resources/tiles/3.png")  
    elseif valorImagem == 4 then
        self.imagem = love.graphics.newImage("resources/tiles/4.png")  
    elseif valorImagem == 5 then
        self.imagem = love.graphics.newImage("resources/tiles/5.png")  
    elseif valorImagem == 6 then
        self.imagem = love.graphics.newImage("resources/tiles/6.png")  
    elseif valorImagem == 7 then
        self.imagem = love.graphics.newImage("resources/tiles/7.png")  
    elseif valorImagem == 8 then
        self.imagem = love.graphics.newImage("resources/tiles/8.png")  
    elseif valorImagem == 9 then
        self.imagem = love.graphics.newImage("resources/tiles/9.png")  
    elseif valorImagem == 10 then
        self.imagem = love.graphics.newImage("resources/tiles/10.png")  
    elseif valorImagem == 11 then
        self.imagem = love.graphics.newImage("resources/tiles/11.png")  
    elseif valorImagem == 12 then
        self.imagem = love.graphics.newImage("resources/tiles/12.png")  
    elseif valorImagem == 13 then
        self.imagem = love.graphics.newImage("resources/tiles/13.png")  
    elseif valorImagem == 14 then
        self.imagem = love.graphics.newImage("resources/tiles/14.png")  
    elseif valorImagem == 15 then
        self.imagem = love.graphics.newImage("resources/tiles/15.png")  
    elseif valorImagem == 16 then
        self.imagem = love.graphics.newImage("resources/tiles/16.png")  
    elseif valorImagem == 17 then
        self.imagem = love.graphics.newImage("resources/tiles/17.png")  
    elseif valorImagem == 18 then
        self.imagem = love.graphics.newImage("resources/tiles/18.png")  
    elseif valorImagem == 19 then
        self.imagem = love.graphics.newImage("resources/tiles/19.png")  
    elseif valorImagem == 20 then
        self.imagem = love.graphics.newImage("resources/tiles/20.png")  
    elseif valorImagem == 21 then
        self.imagem = love.graphics.newImage("resources/tiles/21.png")  
    elseif valorImagem == 22 then
        self.imagem = love.graphics.newImage("resources/tiles/22.png")  
    elseif valorImagem == 23 then
        self.imagem = love.graphics.newImage("resources/tiles/23.png")  
    elseif valorImagem == 30 then
        self.imagem = love.graphics.newImage("resources/tiles/30.png")  
        self.y = self.y - 3

        
        
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

function Objeto:draw()
    if self.visible then 
        local px = self.x
        local py = self.y
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.imagem, px, py)
    end
end

return Objeto
