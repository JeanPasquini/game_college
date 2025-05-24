local functionObjeto = {}

-- Tamanho fixo do jogador
local PLAYER_WIDTH = 64
local PLAYER_HEIGHT = 42

function functionObjeto.checkCollision(player, objeto)
    return player.x < objeto.x + objeto.width and
           player.x + PLAYER_WIDTH > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + PLAYER_HEIGHT > objeto.y
end

function functionObjeto.handleCollisions(player, objetos)
    local px, py = player.x, player.y
    for _, objeto in ipairs(objetos) do
        local ox, oy, ow, oh = objeto.x, objeto.y, objeto.width, objeto.height

        if functionObjeto.checkCollision(player, objeto) then
            local overlapLeft   = (px + PLAYER_WIDTH) - ox
            local overlapRight  = (ox + ow) - px
            local overlapTop    = (py + PLAYER_HEIGHT) - oy
            local overlapBottom = (oy + oh) - py

            local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)

            if minOverlap == overlapLeft then
                player.x = ox - PLAYER_WIDTH
            elseif minOverlap == overlapRight then
                player.x = ox + ow
            elseif minOverlap == overlapTop then
                player.y = oy - PLAYER_HEIGHT
                player.velocidadeY = 0
            elseif minOverlap == overlapBottom then
                player.y = oy + oh
            end

            -- Atualiza posição atualizada para os próximos objetos
            px, py = player.x, player.y
        end
    end
end

return functionObjeto
