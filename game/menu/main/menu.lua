local menu = {}

function menu.load(gameState)
    menu.gameState = gameState
    menu.fonte = love.graphics.newFont(40)

    menu.botoes = {
        { texto = "Mapa 1", x = 760, y = 300, largura = 400, altura = 100, acao = function() menu.gameState.estado = "mapa1" end },
        { texto = "Configurações", x = 760, y = 450, largura = 400, altura = 100, acao = function() print("Abrindo configurações...") end },
        { texto = "Sair", x = 760, y = 600, largura = 400, altura = 100, acao = function() love.event.quit() end }
    }
end

function menu.draw()
    love.graphics.setFont(menu.fonte)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) 

    for _, botao in ipairs(menu.botoes) do
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura, 20, 20)

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(botao.texto, botao.x, botao.y + 30, botao.largura, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        for _, botao in ipairs(menu.botoes) do
            if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
                botao.acao()
            end
        end
    end
end

return menu
