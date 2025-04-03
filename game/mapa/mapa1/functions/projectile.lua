local functionProjetile = {}

function functionProjetile.checkCollisionProjectile(proj, objeto)
    return proj.x < objeto.x + objeto.width and
           proj.x + 5 > objeto.x and
           proj.y < objeto.y + objeto.height and
           proj.y + 5 > objeto.y
end

function functionProjetile.handleProjectileCollisions(players, objetos)
    for _, player in ipairs(players) do
        for i = #player.projectiles, 1, -1 do
            local proj = player.projectiles[i]
            for _, objeto in ipairs(objetos) do
                if functionProjetile.checkCollisionProjectile(proj, objeto) then
                    table.remove(player.projectiles, i)

                    for j = #objetos, 1, -1 do
                        local objeto2 = objetos[j]
                        local dist = math.sqrt((objeto2.x - proj.x)^2 + (objeto2.y - proj.y)^2)
                        if dist <= 100 then
                            table.remove(objetos, j)
                            objeto2 = nil
                        end
                    end

                    -- Verifica se algum jogador foi atingido
                    for _, target in ipairs(players) do
                        local distPlayer = math.sqrt((target.x - proj.x)^2 + (target.y - proj.y)^2)
                        if distPlayer <= 100 then
                            target.life = math.max(target.life - 1, 0)
                        end
                    end

                    break
                end
            end
        end
    end
end

return functionProjetile