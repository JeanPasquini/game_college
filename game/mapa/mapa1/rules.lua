local Rules = {}

function Rules.checkCollision(player, objeto)
    return player.x < objeto.x + objeto.width and
           player.x + 32 > objeto.x and
           player.y < objeto.y + objeto.height and
           player.y + 32 > objeto.y
end

function Rules.handleCollisions(player, objetos)
    for _, objeto in ipairs(objetos) do
        if Rules.checkCollision(player, objeto) then
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

function Rules.checkCollisionAgua(player, agua)
    return player.x < agua.x + agua.width and
           player.x + 32 > agua.x and
           player.y < agua.y + agua.height and
           player.y + 32 > agua.y
end

function Rules.handleCollisionsAgua(player, aguas)
    for _, agua in ipairs(aguas) do
        if Rules.checkCollisionAgua(player, agua) then
            player.visible = false
        end
    end
end

function Rules.checkCollisionProjectile(proj, objeto)
    return proj.x < objeto.x + objeto.width and
           proj.x + 5 > objeto.x and
           proj.y < objeto.y + objeto.height and
           proj.y + 5 > objeto.y
end

function Rules.handleProjectileCollisions(player, objetos)
    for i = #player.projectiles, 1, -1 do
        local proj = player.projectiles[i]
        for _, objeto in ipairs(objetos) do
            if Rules.checkCollisionProjectile(proj, objeto) then
                table.remove(player.projectiles, i)

                for j = #objetos, 1, -1 do 
                    local objeto2 = objetos[j]
                    local dist = math.sqrt((objeto2.x - proj.x)^2 + (objeto2.y - proj.y)^2)
                    if dist <= 100 then
                        table.remove(objetos, j)
                        objeto2 = nil 
                    end
                end

                break
            end
        end
    end
end

return Rules
