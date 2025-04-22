local menu = {}

function menu.load(gameState)
    menu.gameState = gameState
    menu.fonte = love.graphics.newFont("font/PressStart2P-Regular.ttf", 14)
    menu.tituloFonte = love.graphics.newFont("font/PressStart2P-Regular.ttf", 24)
    menu.backgroundImage = love.graphics.newImage("resources/backgrounds/main/1.png")

    -- Obtém as dimensões da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Proporção do botão em relação à largura e altura da tela
    local buttonWidth = screenWidth * 0.2  -- 40% da largura da tela
    local buttonHeight = screenHeight * 0.08  -- 8% da altura da tela
    local buttonSpacing = screenHeight * 0.02  -- 2% da altura da tela

    -- Cálculo da posição vertical inicial
    local startY = (screenHeight - (4 * buttonHeight + 3 * buttonSpacing)) / 2 + 40

    -- Proporção da área do menu
    local menuAreaX = screenWidth * 0.7  -- 70% da largura da tela
    local menuAreaWidth = screenWidth * 0.3  -- 30% da largura da tela
    local buttonX = menuAreaX + (menuAreaWidth - buttonWidth) / 2

    -- Inicializa os botões do menu
    menu.botoes = {
        { texto = "JOGAR",       x = buttonX, y = startY, altura = buttonHeight, largura = buttonWidth, acao = function() menu.gameState.estado = "selectCharacter" end, hover = false },
        { texto = "CONFIGURAÇÃO", x = buttonX, y = startY + (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() menu.gameState.estado = "configuracao" end, hover = false },
        { texto = "CREDITOS",  x = buttonX, y = startY + 2 * (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() menu.gameState.estado = "creditos" end, hover = false },
        { texto = "SAIR",      x = buttonX, y = startY + 3 * (buttonHeight + buttonSpacing), altura = buttonHeight, largura = buttonWidth, acao = function() love.event.quit() end, hover = false }
    }

    -- Para o menu de configurações
    menu.somAtivo = true  -- Variável para controlar se o som está ativo ou não
    menu.volumeGeral = 0.5
    menu.volumeEfeitos = 0.5
    menu.volumeMusica = 0.5

    -- Ajuste de volume (Barra deslizante) com base na largura da tela
    local sliderWidth = menuAreaWidth * 0.8  -- 90% da largura do menu
    local sliderX = menuAreaX + (menuAreaWidth - sliderWidth) / 2  -- Centraliza os sliders dentro da área do menu

    -- Ajuste a posição Y dos sliders de maneira proporcional
    local sliderSpacing = screenHeight * 0.05  -- Espaçamento proporcional entre os sliders
    menu.volumeGeralSlider = {x = sliderX, y = startY + (buttonHeight * 2 + buttonSpacing * 2), largura = sliderWidth, valor = menu.volumeGeral}
    menu.volumeEfeitosSlider = {x = sliderX, y = menu.volumeGeralSlider.y + sliderSpacing, largura = sliderWidth, valor = menu.volumeEfeitos}
    menu.volumeMusicaSlider = {x = sliderX, y = menu.volumeEfeitosSlider.y + sliderSpacing, largura = sliderWidth, valor = menu.volumeMusica}

    -- Inicializa os botões de configuração com ajuste proporcional
    menu.configuracaoBotoes = {
        { texto = "Aplicar",       x = buttonX, y = startY , altura = buttonHeight, largura = buttonWidth, acao = function() menu.gameState.estado = "menu" end, hover = false }
    }
end



function menu.update(dt)
    -- Atualiza os valores dos sliders
end

function menu.draw()
    love.graphics.setFont(menu.tituloFonte)
    love.graphics.clear(0, 0, 0)

    -- Fundo do jogo
    local scaleY = love.graphics.getHeight() / menu.backgroundImage:getHeight()
    local deslocamentoX = -love.graphics.getWidth() * 0.04
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(menu.backgroundImage, deslocamentoX, 0, 0, scaleY, scaleY)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local menuAreaX = screenWidth * 0.7
    local menuAreaWidth = screenWidth * 0.3

    -- Painel do menu com cor sólida
    love.graphics.setColor(0.18, 0.12, 0.19) -- #2D1E2F (bordô escuro)
    love.graphics.rectangle("fill", menuAreaX, 0, menuAreaWidth, screenHeight)

    -- Moldura do painel
    love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", menuAreaX + 4, 4, menuAreaWidth - 8, screenHeight - 8)

    -- Título
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("TACTICAL\nTANKS", menuAreaX, 50, menuAreaWidth, "center")

    love.graphics.setFont(menu.fonte)

    -- Se a configuração for ativada, desenha o menu de som
    if menu.gameState.estado == "configuracao" then
        -- Mostrar opções de som
        for _, botao in ipairs(menu.configuracaoBotoes) do
            if botao.hover then
                love.graphics.setColor(0.42, 0.7, 0.42) -- Hover: verde claro
            else
                love.graphics.setColor(0.29, 0.5, 0.29) -- Normal: verde escuro
            end
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)

            -- Moldura do botão
            love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            -- Texto
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(botao.texto, botao.x, botao.y + (botao.altura / 2) - 10, botao.largura, "center")
        end

        -- Desenha os sliders de volume
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
        -- Botões do menu principal, apenas se não estiver na configuração
        for _, botao in ipairs(menu.botoes) do
            if botao.hover then
                love.graphics.setColor(0.42, 0.7, 0.42) -- Hover: verde claro
            else
                love.graphics.setColor(0.29, 0.5, 0.29) -- Normal: verde escuro
            end
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)

            -- Moldura do botão
            love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            -- Texto
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(botao.texto, botao.x, botao.y + (botao.altura / 2) - 10, botao.largura, "center")
        end
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        -- Lidar com cliques nos botões do menu principal
        if menu.gameState.estado ~= "configuracao" then
            for _, botao in ipairs(menu.botoes) do
                if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
                    botao.acao()
                end
            end
        end

        -- Lidar com cliques nos botões do menu de configurações
        if menu.gameState.estado == "configuracao" then
            for _, botao in ipairs(menu.configuracaoBotoes) do
                if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
                    botao.acao()
                end
            end
        
            -- Lidar com cliques nos sliders para volume
            if x > menu.volumeGeralSlider.x and x < menu.volumeGeralSlider.x + menu.volumeGeralSlider.largura and y > menu.volumeGeralSlider.y and y < menu.volumeGeralSlider.y + 10 then
                menu.volumeGeral = (x - menu.volumeGeralSlider.x) / menu.volumeGeralSlider.largura
                -- Atualiza o volume geral do jogo, afetando música e efeitos
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
        
            -- Garantir que os volumes sejam zerados corretamente
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
