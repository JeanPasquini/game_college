local menu = {}
menu.githubIcon = love.graphics.newImage("resources/icons/github_icon_bg.png")
menu.instagramIcon = love.graphics.newImage("resources/icons/instagram_icon_bg.png")


local transition = require("menu.main.transition")

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

        table.insert(menu.configuracaoBotoes, {
            texto = "Tela Cheia",
            x = 0, y = 0, largura = 0, altura = 0, hover = false,
            acao = function()
                local fullscreen = love.window.getFullscreen()
                love.window.setFullscreen(not fullscreen, "desktop")
            end
        })


        screenWidth, screenHeight = love.graphics.getDimensions()

        menu.githubIcon = love.graphics.newImage("resources/icons/github_icon_bg.png")
        menu.instagramIcon = love.graphics.newImage("resources/icons/instagram_icon_bg.png")

        local iconSize = screenHeight * 0.04
        local iconSpacing = screenHeight * 0.02
        local totalIconsWidth = iconSize * 2 + iconSpacing
        local iconsX = (screenWidth - totalIconsWidth) / 2
        local iconsY = screenHeight - iconSize - 50

        menu.githubArea = {x = iconsX, y = iconsY, w = iconSize, h = iconSize}
        menu.instagramArea = {x = iconsX + iconSize + iconSpacing, y = iconsY, w = iconSize, h = iconSize}
end



function menu.update(dt)

end

function menu.draw()



    love.graphics.setFont(menu.tituloFonte)
    love.graphics.clear(0, 0, 0)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local scaleY = love.graphics.getHeight() / menu.backgroundImage:getHeight()
    local deslocamentoX = -love.graphics.getWidth() * 0.04
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(menu.backgroundImage, deslocamentoX, 0, 0, scaleY, scaleY)

    local menuAreaX = screenWidth * 0.7
    local menuAreaWidth = screenWidth * 0.3

    love.graphics.setColor(0.18, 0.12, 0.19) 
    love.graphics.rectangle("fill", menuAreaX, 0, menuAreaWidth, screenHeight)

    love.graphics.setColor(1, 1, 0.6)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", menuAreaX + 4, 4, menuAreaWidth - 8, screenHeight - 8)

    local titleFontSize = screenHeight * 0.06
    local titleFont = love.graphics.newFont("font/PressStart2P-Regular.ttf", math.floor(titleFontSize))
    love.graphics.setFont(titleFont)
    drawTextWithBorderMultiline(
        "MENU\n",
        menuAreaX,
        screenHeight * 0.05,
        menuAreaWidth,
        "center",
        titleFont,
        {1,1,1,1},
        {0,0,0,1},
        1
    )

    love.graphics.setFont(menu.fonte)

    local buttonHeight = screenHeight * 0.08
    local buttonSpacing = screenHeight * 0.02
    local buttonWidth = menuAreaWidth * 0.8
    local buttonX = menuAreaX + (menuAreaWidth - buttonWidth) / 2

    if menu.gameState.estado == "configuracao" then
        for i, botao in ipairs(menu.configuracaoBotoes) do
            botao.largura = buttonWidth
            botao.altura = buttonHeight
            botao.x = buttonX
            botao.y = screenHeight * 0.3 + (i - 1) * (buttonHeight + buttonSpacing)

            love.graphics.setColor(botao.hover and {0.42, 0.7, 0.42} or {0.29, 0.5, 0.29})
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)

            love.graphics.setColor(1, 1, 0.6)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            local font = love.graphics.getFont()
            local textWidth = font:getWidth(botao.texto)
            local textHeight = font:getHeight()
            local textX = botao.x + (botao.largura - textWidth) / 2
            local textY = botao.y + (botao.altura - textHeight) / 2

            drawTextWithBorder(botao.texto, textX, textY, font, {1, 1, 1}, {0, 0, 0}, 1)
        end

        for i, botao in ipairs(menu.configuracaoBotoes) do
            botao.largura = buttonWidth
            botao.altura = buttonHeight
            botao.x = buttonX
            botao.y = screenHeight * 0.3 + (i - 1) * (buttonHeight + buttonSpacing)
        end

        local sliderWidth = menuAreaWidth * 0.7
        local sliderHeight = 10
        local sliderX = menuAreaX + (menuAreaWidth - sliderWidth) / 2
        local sliderYStart = screenHeight * 0.55
        local sliderSpacing = screenHeight * 0.08

        menu.volumeGeralSlider.x = sliderX
        menu.volumeGeralSlider.y = sliderYStart
        menu.volumeGeralSlider.largura = sliderWidth

        menu.volumeEfeitosSlider.x = sliderX
        menu.volumeEfeitosSlider.y = sliderYStart + sliderSpacing
        menu.volumeEfeitosSlider.largura = sliderWidth

        menu.volumeMusicaSlider.x = sliderX
        menu.volumeMusicaSlider.y = sliderYStart + sliderSpacing * 2
        menu.volumeMusicaSlider.largura = sliderWidth

        local font = love.graphics.getFont()

        drawTextWithBorder("Volume Geral", sliderX, sliderYStart - 20, font, {1,1,1,1}, {0,0,0,1}, 1)
        love.graphics.rectangle("line", sliderX, sliderYStart, sliderWidth, sliderHeight)
        love.graphics.circle("fill", sliderX + sliderWidth * menu.volumeGeral, sliderYStart + sliderHeight / 2, sliderHeight)

        drawTextWithBorder("Volume Efeitos", sliderX, sliderYStart + sliderSpacing - 20, font, {1,1,1,1}, {0,0,0,1}, 1)
        love.graphics.rectangle("line", sliderX, sliderYStart + sliderSpacing, sliderWidth, sliderHeight)
        love.graphics.circle("fill", sliderX + sliderWidth * menu.volumeEfeitos, sliderYStart + sliderSpacing + sliderHeight / 2, sliderHeight)

        drawTextWithBorder("Volume Música", sliderX, sliderYStart + sliderSpacing * 2 - 20, font, {1,1,1,1}, {0,0,0,1}, 1)
        love.graphics.rectangle("line", sliderX, sliderYStart + sliderSpacing * 2, sliderWidth, sliderHeight)
        love.graphics.circle("fill", sliderX + sliderWidth * menu.volumeMusica, sliderYStart + sliderSpacing * 2 + sliderHeight / 2, sliderHeight)

    else
        for i, botao in ipairs(menu.botoes) do
            botao.largura = buttonWidth
            botao.altura = buttonHeight
            botao.x = buttonX
            botao.y = screenHeight * 0.3 + (i - 1) * (buttonHeight + buttonSpacing)

            love.graphics.setColor(botao.hover and {0.42, 0.7, 0.42} or {0.29, 0.5, 0.29})
            love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)

            love.graphics.setColor(1, 1, 0.6)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", botao.x, botao.y, botao.largura, botao.altura)

            local font = love.graphics.getFont()
            local textWidth = font:getWidth(botao.texto)
            local textHeight = font:getHeight()
            local textX = botao.x + (botao.largura - textWidth) / 2
            local textY = botao.y + (botao.altura - textHeight) / 2

            drawTextWithBorder(botao.texto, textX, textY, font, {1,1,1,1}, {0,0,0,1}, 1)
        end
    end

    local footerText = "©Todos os direitos reservados."
    local footerFontSize = screenHeight * 0.015
    local footerFont = love.graphics.newFont("font/PressStart2P-Regular.ttf", math.floor(footerFontSize))
    love.graphics.setFont(footerFont)

    local textWidth = footerFont:getWidth(footerText)
    local textHeight = footerFont:getHeight()
    local textX = menuAreaX + (menuAreaWidth - textWidth) / 2
    local textY = screenHeight - textHeight - 10 

    drawTextWithBorder(footerText, textX, textY, footerFont, {1,1,1,1}, {0,0,0,1}, 1)

    local iconSize = screenHeight * 0.09
    local iconSpacing = screenHeight * 0.02
    local totalIconsWidth = iconSize * 2 + iconSpacing
    local iconsX = menuAreaX + (menuAreaWidth - totalIconsWidth) / 2
    local iconsY = screenHeight - iconSize - 70 

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(menu.githubIcon, iconsX, iconsY, 0, iconSize / menu.githubIcon:getWidth(), iconSize / menu.githubIcon:getHeight())
    love.graphics.draw(menu.instagramIcon, iconsX + iconSize + iconSpacing, iconsY, 0, iconSize / menu.instagramIcon:getWidth(), iconSize / menu.instagramIcon:getHeight())

    menu.githubArea = {x = iconsX, y = iconsY, w = iconSize, h = iconSize}
    menu.instagramArea = {x = iconsX + iconSize + iconSpacing, y = iconsY, w = iconSize, h = iconSize}


end


function menu.mousepressed(x, y, button)
    if button == 1 then
        if menu.githubArea and
            x >= menu.githubArea.x and x <= menu.githubArea.x + menu.githubArea.w and
            y >= menu.githubArea.y and y <= menu.githubArea.y + menu.githubArea.h then
            love.system.openURL("https://github.com/JeanPasquini/game_college")
        elseif menu.instagramArea and
            x >= menu.instagramArea.x and x <= menu.instagramArea.x + menu.instagramArea.w and
            y >= menu.instagramArea.y and y <= menu.instagramArea.y + menu.instagramArea.h then
            love.system.openURL("https://www.instagram.com/https.pasquini/")
            love.system.openURL("https://www.instagram.com/filipi_biazoto/")
        end

        efeitoSonoro:play("sounds/soundeffect/click.wav")
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
    if not menu.botoes or not menu.configuracaoBotoes then return end

    for _, botao in ipairs(menu.botoes) do
        botao.hover = x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura
    end
    for _, botao in ipairs(menu.configuracaoBotoes) do
        botao.hover = x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura
    end
end


return menu
