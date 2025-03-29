local Objeto = require("mapa.library.objeto") 
local Agua = require("mapa.library.agua") 
local mapa1 = {}
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")

local player
local objetosMapa1 = {}
local aguasMapa1 = {}

function mapa1.load(gameState)
    mapa1.gameState = gameState
    mapa1.debugAtivo = false
    config.load()
    debug.load() 
    
    player = Player.new(1100, 100)
    
    for _, objeto in ipairs(config.objetos) do
        table.insert(objetosMapa1, Objeto.new(objeto.x, objeto.y, objeto.cor))
    end
    
    for _, agua in ipairs(config.aguas) do
        table.insert(aguasMapa1, Agua.new(agua.x, agua.y, agua.cor))
    end
end


function mapa1.draw()
    config.draw()

    for _, objeto in ipairs(objetosMapa1) do
        objeto:draw()
    end
    
    for _, agua in ipairs(aguasMapa1) do
        agua:draw()
    end

    if player and player.visible then
        player:draw()
    end

    debug.draw(mapa1.debugAtivo)
end


function mapa1.update(dt)
    if player and player.visible then
        player:update()
        player:handleCollisions(objetosMapa1)
        player:handleCollisions2(aguasMapa1)
    end
end

function mapa1.keypressed(key)
    if key == "'" then
        mapa1.debugAtivo = not mapa1.debugAtivo
    end
end

function checkCollision(player, objeto)
    return player.x < objeto.x + objeto.width and
           player.x + 32 > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + 32 > objeto.y
end

function Player:handleCollisions(objetos)
    for _, objeto in ipairs(objetos) do
        if checkCollision(self, objeto) then
            local overlapLeft = self.x + 32 - objeto.x
            local overlapRight = objeto.x + objeto.width - self.x
            local overlapTop = self.y + 32 - objeto.y
            local overlapBottom = objeto.y + objeto.height - self.y

            local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)

            if minOverlap == overlapLeft then
                self.x = objeto.x - 32
            elseif minOverlap == overlapRight then
                self.x = objeto.x + objeto.width 
            elseif minOverlap == overlapTop then
                self.y = objeto.y - 32 
                self.velocidadeY = 0
            elseif minOverlap == overlapBottom then
                self.y = objeto.y + objeto.height 
            end
        end
    end
end


function checkCollisionAgua(player, agua)
    return player.x < agua.x + agua.width and
           player.x + 32 > agua.x and
           player.y < agua.y + agua.height and
           player.y + 32 > agua.y
end

function Player:handleCollisions2(aguas)
    for _, agua in ipairs(aguas) do
        if checkCollisionAgua(self, agua) then
            player = nil
        end
    end
end

return mapa1
