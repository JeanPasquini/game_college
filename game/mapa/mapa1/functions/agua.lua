local functionAgua = {}

function functionAgua.checkCollisionAgua(player, agua)
    return player.x < agua.x + agua.width and
           player.x + 32 > agua.x and
           player.y < agua.y + agua.height and
           player.y + 32 > agua.y
end

function functionAgua.handleCollisionsAgua(player, aguas)
    for _, agua in ipairs(aguas) do
        if functionAgua.checkCollisionAgua(player, agua) then
            player.visible = false
        end
    end
end

return functionAgua