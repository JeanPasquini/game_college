local functionObjetoInquebravel = {}

local PLAYER_WIDTH = 64
local PLAYER_HEIGHT = 42

function functionObjetoInquebravel.checkCollision(player, obj)
    return player.x < obj.x + obj.width and
           player.x + PLAYER_WIDTH > obj.x and
           player.y < obj.y + obj.height and
           player.y + PLAYER_HEIGHT > obj.y
end

function functionObjetoInquebravel.handleCollisions(player, objetos)
    for _, obj in ipairs(objetos) do
        if functionObjetoInquebravel.checkCollision(player, obj) then
            local px, py = player.x, player.y
            local ow, oh = obj.width, obj.height
            local ox, oy = obj.x, obj.y

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
        end
    end
end

return functionObjetoInquebravel
