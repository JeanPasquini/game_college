local functionObjeto = {}

function functionObjeto.checkCollision(player, objeto)
    return player.x < objeto.x + objeto.width and
           player.x + 32 > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + 32 > objeto.y
end

function functionObjeto.handleCollisions(player, objetos)
    for _, objeto in ipairs(objetos) do
        if functionObjeto.checkCollision(player, objeto) then
            local overlapLeft = player.x + 32 - objeto.x
            local overlapRight = objeto.x + objeto.width - player.x
            local overlapTop = player.y + 32 - objeto.y
            local overlapBottom = objeto.y + objeto.height - player.y

            local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)

            if minOverlap == overlapLeft then
                player.x = objeto.x - 32
            elseif minOverlap == overlapRight then
                player.x = objeto.x + objeto.width 
            elseif minOverlap == overlapTop then
                player.y = objeto.y - 32 
                player.velocidadeY = 0
            elseif minOverlap == overlapBottom then
                player.y = objeto.y + objeto.height 
            end
        end
    end
end

return functionObjeto
