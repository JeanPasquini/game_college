local functionObjeto = {}

function functionObjeto.checkCollision(player, objeto)
    return player.x < objeto.x + objeto.width and
           player.x + 64 > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + 42 > objeto.y
end

function functionObjeto.handleCollisions(player, objetos)
    for _, objeto in ipairs(objetos) do
        if functionObjeto.checkCollision(player, objeto) then
            local overlapLeft = player.x + 64 - objeto.x
            local overlapRight = objeto.x + objeto.width - player.x
            local overlapTop = player.y + 42 - objeto.y
            local overlapBottom = objeto.y + objeto.height - player.y

            local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)

            if minOverlap == overlapLeft then
                player.x = objeto.x - 64
            elseif minOverlap == overlapRight then
                player.x = objeto.x + objeto.width 
            elseif minOverlap == overlapTop then
                player.y = objeto.y - 42
                player.velocidadeY = 0
            elseif minOverlap == overlapBottom then
                player.y = objeto.y + objeto.height 
            end
        end
    end
end

return functionObjeto
