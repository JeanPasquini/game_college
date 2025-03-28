local Objeto = require("mapa.mapa1.objeto") 
local Agua = require("mapa.mapa1.agua") 
local mapa1 = {}
local config = require("mapa.mapa1.config")
local debug = require("mapa.mapa1.debug")
local Player = require("player.player")

local player
local objetosMapa1 = {}
local aguasMapa1 = {}

function mapa1.load(gameState)
    mapa1.gameState = gameState
    mapa1.debugAtivo = false
    config.load()
    debug.load()

    player = Player.new(100, 100)
    
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

    -- Verificar se o player está visível antes de desenhá-lo
    if player and player.visible then
        player:draw()
    end

    if mapa1.debugAtivo then
        debug.draw()
    end
end

function mapa1.update(dt)
    -- Verificar se o player está visível antes de atualizar
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
           player.x + 100 > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + 40 > objeto.y
end

function checkCollisionAgua(player, agua)
    -- Corrigir a comparação das coordenadas para a água
    return player.x < agua.x + agua.width and
           player.x + 100 > agua.x and
           player.y < agua.y + agua.height and
           player.y + 40 > agua.y
end

function Player:handleCollisions(objetos)
    for _, objeto in ipairs(objetos) do
        if checkCollision(self, objeto) then
            self.y = objeto.y - 40
            self.velocidadeY = 0 
        end
    end
end

function Player:handleCollisions2(aguas)
    for _, agua in ipairs(aguas) do
        if checkCollisionAgua(self, agua) then
            player.visible = false
        end
    end
end

return mapa1
