local menu = {}

function menu.load(gameState)
    menu.gameState = gameState
    menu.fonte = love.graphics.newFont("font/PressStart2P-Regular.ttf", 14)
    menu.tituloFonte = love.graphics.newFont("font/PressStart2P-Regular.ttf", 24)
    menu.backgroundImage = love.graphics.newImage("resources/backgrounds/main/1.png")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local buttonWidth = screenWidth * 0.2
    local buttonHeight = screenHeight * 0.08 
    local buttonSpacing = screenHeight * 0.02  

    local startY = (screenHeight - (4 * buttonHeight + 3 * buttonSpacing)) / 2 + 40

    local menuAreaX = screenWidth * 0.7  
    local menuAreaWidth = screenWidth * 0.3 
    local buttonX = menuAreaX + (menuAreaWidth - buttonWidth) / 2

    menu.botoes = {
        { texto = "JOGAR",       x = buttonX, y = startY, altura = buttonHeight, largura = buttonWidth, acao = function() trocarEstado("selectCharacter") end, hover = false },
        { texto = "CONFIGURAÇÃO", x = buttonX, y = startY + (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() trocarEstado("configuracao") end, hover = false },
        { texto = "CREDITOS",  x = buttonX, y = startY + 2 * (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() trocarEstado("creditos") end, hover = false },
        { texto = "SAIR",      x = buttonX, y = startY + 3 * (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() love.event.quit() end, hover = false }
    }

    menu.somAtivo = true 
    menu.volumeGeral = 0.5
    menu.volumeEfeitos = 0.5
    menu.volumeMusica = 0.5

    local sliderWidth = menuAreaWidth * 0.8 
    local sliderX = menuAreaX + (menuAreaWidth - sliderWidth) / 2  

    local sliderSpacing = screenHeight * 0.05 
    menu.volumeGeralSlider = {x = sliderX, y = startY + (buttonHeight * 2 + buttonSpacing * 2), largura = sliderWidth, valor = menu.volumeGeral}
    menu.volumeEfeitosSlider = {x = sliderX, y = menu.volumeGeralSlider.y + sliderSpacing, largura = sliderWidth, valor = menu.volumeEfeitos}
    menu.volumeMusicaSlider = {x = sliderX, y = menu.volumeEfeitosSlider.y + sliderSpacing, largura = sliderWidth, valor = menu.volumeMusica}

    menu.configuracaoBotoes = {
        { texto = "Aplicar",       x = buttonX, y = startY , altura = buttonHeight, largura = buttonWidth, acao = function() trocarEstado("menu") end, hover = false }
    }
end



function menu.update(dt)

end

function menu.draw()
    love.graphics.setFont(menu.tituloFonte)
    love.graphics.clear(0, 0, 0)

    local scaleY = love.graphics.getHeight() / menu.backgroundImage:getHeight()
    local deslocamentoX = -love.graphics.getWidth() * 0.04
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(menu.backgroundImage, deslocamentoX, 0, 0, scaleY, scaleY)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local menuAreaX = screenWidth * 0.7
    local menuAreaWidth = screenWidth * 0.3

    love.graphics.setColor(0.18, 0.12, 0.19) 
    love.graphics.rectangle("fill", menuAreaX, 0, menuAreaWidth, screenHeight)

    love.graphics.setColor(1, 1, 0.6)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", menuAreaX + 4, 4, menuAreaWidth - 8, screenHeight - 8)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("TACTICAL\nTANKS", menuAreaX, 50, menuAreaWidth, "center")

    love.graphics.setFont(menu.fonte)

    if menu.gameState.estado == "configuracao" then
        for _, botao in ipairs(menu.configuracaoBotoes) do
            if botao.hover then
                love.graphics.setColor(0.42, 0.7, 0.42) -- Hover: verde claro
            else
                love.graphics.setColor(0.29, 0.5, 0.29) -- Normal: verde escuro
            end
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)

            love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(botao.texto, botao.x, botao.y + (botao.altura / 2) - 10, botao.largura, "center")
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Volume Geral", menu.volumeGeralSlider.x, menu.volumeGeralSlider.y - 20, menu.volumeGeralSlider.largura, "left")
        love.graphics.rectangle("line", menu.volumeGeralSlider.x, menu.volumeGeralSlider.y, menu.volumeGeralSlider.largura, 10)
        love.graphics.circle("fill", menu.volumeGeralSlider.x + menu.volumeGeralSlider.largura * menu.volumeGeral, menu.volumeGeralSlider.y + 5, 10)

        love.graphics.printf("Volume Efeitos", menu.volumeEfeitosSlider.x, menu.volumeEfeitosSlider.y - 20, menu.volumeEfeitosSlider.largura, "left")
        love.graphics.rectangle("line", menu.volumeEfeitosSlider.x, menu.volumeEfeitosSlider.y, menu.volumeEfeitosSlider.largura, 10)
        love.graphics.circle("fill", menu.volumeEfeitosSlider.x + menu.volumeEfeitosSlider.largura * menu.volumeEfeitos, menu.volumeEfeitosSlider.y + 5, 10)

        love.graphics.printf("Volume Música", menu.volumeMusicaSlider.x, menu.volumeMusicaSlider.y - 20, menu.volumeMusicaSlider.largura, "left")
        love.graphics.rectangle("line", menu.volumeMusicaSlider.x, menu.volumeMusicaSlider.y, menu.volumeMusicaSlider.largura, 10)
        love.graphics.circle("fill", menu.volumeMusicaSlider.x + menu.volumeMusicaSlider.largura * menu.volumeMusica, menu.volumeMusicaSlider.y + 5, 10)
    else
        for _, botao in ipairs(menu.botoes) do
            if botao.hover then
                love.graphics.setColor(0.42, 0.7, 0.42) -- Hover: verde claro
            else
                love.graphics.setColor(0.29, 0.5, 0.29) -- Normal: verde escuro
            end
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)


            love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(botao.texto, botao.x, botao.y + (botao.altura / 2) - 10, botao.largura, "center")
        end
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        if menu.gameState.estado ~= "configuracao" then
            for _, botao in ipairs(menu.botoes) do
                if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
                    botao.acao()
                end
            end
        end

        if menu.gameState.estado == "configuracao" then
            for _, botao in ipairs(menu.configuracaoBotoes) do
                if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
                    botao.acao()
                end
            end
        
            if x > menu.volumeGeralSlider.x and x < menu.volumeGeralSlider.x + menu.volumeGeralSlider.largura and y > menu.volumeGeralSlider.y and y < menu.volumeGeralSlider.y + 10 then
                menu.volumeGeral = (x - menu.volumeGeralSlider.x) / menu.volumeGeralSlider.largura
                musica:setVolume(menu.volumeGeral)
                efeitoSonoro:setVolume(menu.volumeGeral)
            end
            if x > menu.volumeEfeitosSlider.x and x < menu.volumeEfeitosSlider.x + menu.volumeEfeitosSlider.largura and y > menu.volumeEfeitosSlider.y and y < menu.volumeEfeitosSlider.y + 10 then
                menu.volumeEfeitos = (x - menu.volumeEfeitosSlider.x) / menu.volumeEfeitosSlider.largura
                efeitoSonoro:setVolume(menu.volumeEfeitos * menu.volumeGeral)
            end
            if x > menu.volumeMusicaSlider.x and x < menu.volumeMusicaSlider.x + menu.volumeMusicaSlider.largura and y > menu.volumeMusicaSlider.y and y < menu.volumeMusicaSlider.y + 10 then
                menu.volumeMusica = (x - menu.volumeMusicaSlider.x) / menu.volumeMusicaSlider.largura
                musica:setVolume(menu.volumeMusica * menu.volumeGeral)
            end
        
            if menu.volumeGeral == 0 then
                musica:setVolume(0)
                efeitoSonoro:setVolume(0)
            end
        end
        
    end
end


function menu.mousemoved(x, y)
    for _, botao in ipairs(menu.botoes) do
        botao.hover = x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura
    end
    for _, botao in ipairs(menu.configuracaoBotoes) do
        botao.hover = x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura
    end
end

return menu
