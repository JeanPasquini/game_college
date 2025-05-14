local functionObjetoInquebravel = {}

function functionObjetoInquebravel.checkCollision(player, objetoInquebravel)
    return player.x < objetoInquebravel.x + objetoInquebravel.width and
           player.x + 64 > objetoInquebravel.x and
           player.y < objetoInquebravel.y + objetoInquebravel.height and
           player.y + 42 > objetoInquebravel.y
end

function functionObjetoInquebravel.handleCollisions(player, objetosInquebravel)
    for _, objetoInquebravel in ipairs(objetosInquebravel) do
        if functionObjetoInquebravel.checkCollision(player, objetoInquebravel) then
            local overlapLeft = player.x + 64 - objetoInquebravel.x
            local overlapRight = objetoInquebravel.x + objetoInquebravel.width - player.x
            local overlapTop = player.y + 42 - objetoInquebravel.y
            local overlapBottom = objetoInquebravel.y + objetoInquebravel.height - player.y

            local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)

            if minOverlap == overlapLeft then
                player.x = objetoInquebravel.x - 64
            elseif minOverlap == overlapRight then
                player.x = objetoInquebravel.x + objetoInquebravel.width 
            elseif minOverlap == overlapTop then
                player.y = objetoInquebravel.y - 42
                player.velocidadeY = 0
            elseif minOverlap == overlapBottom then
                player.y = objetoInquebravel.y + objetoInquebravel.height 
            end
        end
    end
end

return functionObjetoInquebravel
