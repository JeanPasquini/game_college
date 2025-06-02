local selectCharacter = {}
local visiblePlayers = 2
local plusButtons = {}
local fontPlayerName
local playerData = {}
local fontButton = love.graphics.newFont("font/PressStart2P-Regular.ttf", 15)
local arrowLeftImage = love.graphics.newImage("resources/icons/arrow_left.png")
local arrowRightImage = love.graphics.newImage("resources/icons/arrow_right.png")

buttonRegras = nil 
local tankImage = love.graphics.newImage("resources/sprites/tank/tank.png") 

local imgRule1
local imgRule2
local imgRule3

local regraDescriptions = {
    "Regra 1: Escolha a classe que melhor se adapta ao seu estilo de jogo, considerando suas habilidades e táticas preferidas.",
    
    "Regra 2: Após o carregamento da partida, posicione seu tanque estrategicamente para obter vantagem no combate e proteger seus pontos de vida.",
    
    "Regra 3: Para vencer a partida, elimine todos os jogadores adversários presentes no campo de batalha, utilizando suas habilidades com precisão e atenção."
}

local mostrarRegras = false

local classColors = {
    {1, 1, 1, 1}, 
    {1, 0.4, 0.4, 1},    
    {0.5, 0.9, 0.9, 1},    
    {0.3, 0.5, 1, 1} 
}

local characterClasses = {
    { name = "T. Comum", vida = "150", dano = "100", salto = "  2" },
    { name = "T. Goliath X", vida = "250", dano = " 75", salto = "  1" },
    { name = "T. Lightning Viper", vida = "150", dano = " 75", salto = "  4" },
    { name = "T. Doombringer", vida = "100", dano = "150", salto = "  1" }
}


local classIcons = {
    love.graphics.newImage("resources/icons/icon_tanque_comum.png"),
    love.graphics.newImage("resources/icons/icon_tanque_goliath_x.png"),
    love.graphics.newImage("resources/icons/icon_tanque_lightning_viper.png"),
    love.graphics.newImage("resources/icons/icon_tanque_doombringer.png"),
}

tankTypes = {} 

function selectCharacter.load(gameState, quantidadeJogadores)
    imgRule1 = love.graphics.newImage("resources/rules/rule1.png")
    imgRule2 = love.graphics.newImage("resources/rules/rule2.png")
    imgRule3 = love.graphics.newImage("resources/rules/rule3.png")

    regraImages = { imgRule1, imgRule2, imgRule3 }
    selectCharacter.gameState = gameState
    selectCharacter.quantidadeJogadores = quantidadeJogadores
    visiblePlayers = 2
    plusButtons = {}
    fontPlayerName = love.graphics.newFont("font/PressStart2P-Regular.ttf", 15)
    background = love.graphics.newImage("resources/backgrounds/background5.png")

    playerData = {}
    tankTypes = {}

    for i = 1, 4 do
        playerData[i] = { classIndex = 1 }
        tankTypes[i] = 1 
    end
end

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scale = math.max(windowWidth / bgWidth, windowHeight / bgHeight)
    love.graphics.draw(background, 0, 0, 0, scale, scale)
end

function selectCharacter.update(dt)
    
end

local iconVida = love.graphics.newImage("resources/icons/fc659.png")
local iconDano = love.graphics.newImage("resources/icons/fc998.png")
local iconSalto = love.graphics.newImage("resources/icons/fc658.png")

function selectCharacter.draw()
    drawBackground()
    local fontTitulo = love.graphics.newFont("font/PressStart2P-Regular.ttf", 28)
    love.graphics.setFont(fontTitulo)


    local screenWidth, screenHeight = love.graphics.getDimensions()

    local squareSize = screenWidth * 0.16
    local margin = screenWidth * 0.07

    local totalWidth = 4 * (squareSize + margin) - margin
    local offsetX = (screenWidth - totalWidth) / 2
    plusButtons = {}

    for i = 1, 4 do
        local x = (i - 1) * (squareSize + margin) + offsetX
        local y = screenHeight * 0.25

        love.graphics.setColor(0.18, 0.12, 0.19)
        love.graphics.rectangle("fill", x, y, squareSize, squareSize, 15)
        love.graphics.setColor(1, 1, 0.6)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", x, y, squareSize, squareSize, 15)

        if i <= visiblePlayers then
            local p = playerData[i]
            local class = characterClasses[p.classIndex]

            love.graphics.setFont(fontPlayerName)
            local nameText = class.name
            local textWidth = fontPlayerName:getWidth(nameText)
            local textHeight = fontPlayerName:getHeight()

            local textX = x + (squareSize - textWidth) / 2
            local textY = y - 28  

            love.graphics.setColor(1, 1, 1)
            drawTextWithBorder(nameText, textX, textY, fontPlayerName, {1, 1, 1}, {0, 0, 0}, 1)

            local scale = 2.5
            local w, h = tankImage:getWidth(), tankImage:getHeight()
            local iconX = x + (squareSize - w * scale) / 2
            local iconY = y + (squareSize - h * scale) / 2

            local color = classColors[p.classIndex] or {1, 1, 1, 1} 
            love.graphics.setColor(color)
            love.graphics.draw(tankImage, iconX, iconY, 0, scale, scale)
            love.graphics.setColor(1, 1, 1, 1)

            local statusY = y + squareSize + 10
            local statusX = x
            local boxWidth, boxHeight = squareSize, 36
            local padding = 8
            local iconSizeSmall = 28
            local textOffset = iconSizeSmall + 14

            local statusList = {
                { icon = iconVida, text = "Vida :" .. class.vida },
                { icon = iconDano, text = "Dano :" .. class.dano },
                { icon = iconSalto, text = "Salto:" .. class.salto },
            }

            for j, status in ipairs(statusList) do
                local boxY = statusY + (j - 1) * (boxHeight + 10)
                love.graphics.setColor(0.18, 0.12, 0.19, 0.85)
                love.graphics.rectangle("fill", statusX, boxY, boxWidth, boxHeight, 8)
                love.graphics.setColor(1, 1, 0.6)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", statusX, boxY, boxWidth, boxHeight, 8)

                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(
                    status.icon,
                    statusX + padding,
                    boxY + (boxHeight - iconSizeSmall) / 2,
                    0,
                    iconSizeSmall / status.icon:getWidth(),
                    iconSizeSmall / status.icon:getHeight()
                )

                love.graphics.setFont(fontPlayerName)

                local textX = statusX + padding + textOffset
                local textY = boxY + (boxHeight - fontPlayerName:getHeight()) / 2

                drawTextWithBorder(status.text, textX, textY, fontPlayerName, {1,1,1}, {0,0,0}, 1)

            end

            local arrowScale = 3.5
            local arrowSize = arrowLeftImage:getWidth() * arrowScale
            local arrowY = y + 130

            p.leftArrow = { x = x - 42, y = arrowY, w = arrowSize, h = arrowLeftImage:getHeight() * arrowScale, index = i, dir = -1 }
            p.rightArrow = { x = x + squareSize, y = arrowY, w = arrowSize, h = arrowLeftImage:getHeight() * arrowScale, index = i, dir = 1 }

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(arrowLeftImage, p.leftArrow.x, p.leftArrow.y, 0, arrowScale, arrowScale)
            love.graphics.draw(arrowRightImage, p.rightArrow.x, p.rightArrow.y, 0, arrowScale, arrowScale)

        else
            local fontPlus = love.graphics.newFont(36)

            love.graphics.setFont(fontPlus)
            love.graphics.setColor(1, 1, 1)
            local text = "+"
            local textWidth = fontPlus:getWidth(text)
            local textHeight = fontPlus:getHeight()
            local textX = x + (squareSize - textWidth) / 2
            local textY = y + (squareSize - textHeight) / 2

            drawTextWithBorder(text, textX, textY, fontPlus, {1, 1, 1}, {0, 0, 0}, 1)

            table.insert(plusButtons, { x = x, y = y, width = squareSize, height = squareSize, slot = i })

        end

        if i <= visiblePlayers then
            
            local p = playerData[i]
            local iconSize = 48
            local iconX = x + squareSize - iconSize - 10
            local iconY = y + 10

            love.graphics.setColor(0.18, 0.12, 0.19, 0.85) 
            love.graphics.rectangle("fill", iconX, iconY, iconSize, iconSize, 12) 

            love.graphics.setColor(1, 1, 0.6)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", iconX, iconY, iconSize, iconSize, 12)

            love.graphics.setFont(fontPlayerName)
            local playerText = "Player " .. i
            local playerTextWidth = fontPlayerName:getWidth(playerText)
            local playerTextX = x + (squareSize - playerTextWidth) / 2
            local playerTextY = y - 60 

            drawTextWithBorder(playerText, playerTextX, playerTextY, fontPlayerName, {1, 1, 1}, {0, 0, 0}, 1)


            local iconImage = classIcons[p.classIndex]
            local iconScale = iconSize / iconImage:getWidth() * 0.7
            local iconOffset = (iconSize - iconImage:getWidth() * iconScale) / 2

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(iconImage, iconX + iconOffset, iconY + iconOffset, 0, iconScale, iconScale)
        end
        
        local titulo = "SELEÇÃO DE TANQUES"
        local tituloX = (screenWidth - fontTitulo:getWidth(titulo)) / 2
        local tituloY = screenHeight * 0.05

        drawTextWithBorder(titulo, tituloX, tituloY, fontTitulo, {1, 1, 1}, {0, 0, 0}, 1)


    end

    local buttonWidth, buttonHeight = screenWidth * 0.2, screenHeight * 0.08
    local buttonSpacing = screenHeight * 0.02
    local buttonX1 = screenWidth * 0.5 - buttonWidth - buttonSpacing * 0.5
    local buttonX2 = screenWidth * 0.5 + buttonSpacing * 0.5
    
    buttonRegras = {
        x = screenWidth * 0.5 - buttonWidth / 2,
        y = screenHeight * 0.75,
        width = buttonWidth,
        height = buttonHeight,
        text = "REGRAS",
        action = function()
            mostrarRegras = not mostrarRegras
        end
    }

    local buttons = {
        { x = buttonX1, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, text = "JOGAR", action = function()
            selectCharacter.quantidadeJogadores = visiblePlayers
            trocarEstado("mapa1")
        end },
        { x = buttonX2, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, text = "VOLTAR", action = function()
            trocarEstado("menu")
        end },
        { x = screenWidth * 0.5 - buttonWidth / 2, y = screenHeight * 0.75, width = buttonWidth, height = buttonHeight, text = "REGRAS", action = function()
            mostrarRegras = not mostrarRegras
        end }
    }

    local mx, my = love.mouse.getPosition()
    local hover = mx > buttonRegras.x and mx < buttonRegras.x + buttonRegras.width and
            my > buttonRegras.y and my < buttonRegras.y + buttonRegras.height

    if hover then
        love.graphics.setColor(0.42, 0.7, 0.42)
    else
        love.graphics.setColor(0.29, 0.5, 0.29)
    end
    love.graphics.rectangle("fill", buttonRegras.x, buttonRegras.y, buttonRegras.width, buttonRegras.height)

    love.graphics.setColor(1, 1, 0.6)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", buttonRegras.x, buttonRegras.y, buttonRegras.width, buttonRegras.height)

    local textWidth = fontButton:getWidth(buttonRegras.text)
    local textHeight = fontButton:getHeight()
    local textX = buttonRegras.x + (buttonRegras.width - textWidth) / 2
    local textY = buttonRegras.y + (buttonRegras.height - textHeight) / 2

    love.graphics.setFont(fontButton)
    drawTextWithBorder(buttonRegras.text, textX, textY, fontButton, {1, 1, 1}, {0, 0, 0}, 1)

    for _, btn in ipairs(buttons) do
        local mx, my = love.mouse.getPosition()
        local hover = mx > btn.x and mx < btn.x + btn.width and my > btn.y and my < btn.y + btn.height

        if hover then
            love.graphics.setColor(0.42, 0.7, 0.42)
        else
            love.graphics.setColor(0.29, 0.5, 0.29)
        end
        love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height)

        love.graphics.setColor(1, 1, 0.6)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)

        local textWidth = fontButton:getWidth(btn.text)
        local textHeight = fontButton:getHeight()
        local textX = btn.x + (btn.width - textWidth) / 2
        local textY = btn.y + (btn.height - textHeight) / 2

        love.graphics.setFont(fontButton)
        drawTextWithBorder(btn.text, textX, textY, fontButton, {1, 1, 1}, {0, 0, 0}, 1)
    end

    if mostrarRegras then
        screenWidth = love.graphics.getWidth()
        screenHeight = love.graphics.getHeight()

        local y = screenHeight * 0.15

        local imgMinWidth = 400
        local imgMinHeight = 400

        local cardWidth = math.max(screenWidth * 0.25, imgMinWidth + 40)
        local cardHeight = cardWidth + 150 
        local spacing = screenWidth * 0.01
        local totalWidth = cardWidth * 3 + spacing * 2
        local startX = (screenWidth - totalWidth) / 2

        local fundoPadding = 30
        local fundoHeight = cardHeight + fundoPadding * 2

        love.graphics.setColor(0.1, 0.07, 0.1, 0.85)
        love.graphics.rectangle("fill", startX - fundoPadding, y - fundoPadding, totalWidth + 2 * fundoPadding, fundoHeight, 15)

        local textColor = {1, 1, 1}      
        local borderColor = {0, 0, 0}      
        local borderThickness = 2

        local minImgScale = math.huge
        for i = 1, 3 do
            local img = regraImages[i]
            local availableWidth = cardWidth * 0.9
            local availableHeight = cardHeight * 0.6
            local scaleX = availableWidth / img:getWidth()
            local scaleY = availableHeight / img:getHeight()
            local imgScale = math.min(scaleX, scaleY)

            local minScaleX = imgMinWidth / img:getWidth()
            local minScaleY = imgMinHeight / img:getHeight()
            local minScale = math.max(minScaleX, minScaleY)

            imgScale = math.max(imgScale, minScale)

            if imgScale < minImgScale then
                minImgScale = imgScale
            end
        end

        local function wrapText(text, maxWidth, font)
            local words = {}
            for word in text:gmatch("%S+") do
                table.insert(words, word)
            end

            local lines = {}
            local currentLine = ""
            for _, word in ipairs(words) do
                local testLine = currentLine == "" and word or (currentLine .. " " .. word)
                if font:getWidth(testLine) <= maxWidth then
                    currentLine = testLine
                else
                    table.insert(lines, currentLine)
                    currentLine = word
                end
            end
            if currentLine ~= "" then
                table.insert(lines, currentLine)
            end
            return lines
        end

        for i = 1, 3 do
            local x = startX + (i - 1) * (cardWidth + spacing)

            love.graphics.setColor(0.18, 0.12, 0.19)
            love.graphics.rectangle("fill", x, y, cardWidth, cardHeight, 12)

            local img = regraImages[i]
            local imgWidth = img:getWidth() * minImgScale
            local imgHeight = img:getHeight() * minImgScale
            local imgX = x + (cardWidth - imgWidth) / 2
            local imgY = y + 20

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(img, imgX, imgY, 0, minImgScale, minImgScale)

            local desc = regraDescriptions[i]
            local maxWidth = cardWidth - 40
            local descY = imgY + imgHeight + 15

            local lines = wrapText(desc, maxWidth, fontButton)
            love.graphics.setFont(fontButton)

            local lineHeight = fontButton:getHeight()
            for j, line in ipairs(lines) do
                local lineWidth = fontButton:getWidth(line)
                local descX = x + (cardWidth - lineWidth) / 2

                local borderOffset = 1
                for dx = -borderOffset, borderOffset do
                    for dy = -borderOffset, borderOffset do
                        if dx ~= 0 or dy ~= 0 then
                            love.graphics.setColor(0, 0, 0)
                            love.graphics.print(line, descX + dx, descY + (j - 1) * lineHeight + dy)
                        end
                    end
                end

                love.graphics.setColor(1, 1, 1)
                love.graphics.print(line, descX, descY + (j - 1) * lineHeight)
            end

            local buttonWidth = 240 
            local buttonHeight = 70  
            local buttonX = (screenWidth - buttonWidth) / 2
            local buttonY = y - screenHeight * 0.02

            local mx, my = love.mouse.getPosition()
            local hover = mx >= buttonX and mx <= buttonX + buttonWidth and my >= buttonY and my <= buttonY + buttonHeight

            if hover then
                love.graphics.setColor(0.42, 0.7, 0.42)
            else
                love.graphics.setColor(0.29, 0.5, 0.29)
            end

            love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)

            love.graphics.setColor(1, 1, 0.6)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)

            local buttonText = "Fechar Regras"
            local textWidth = fontButton:getWidth(buttonText)
            local textHeight = fontButton:getHeight()
            local textX = buttonX + (buttonWidth - textWidth) / 2
            local textY = buttonY + (buttonHeight - textHeight) / 2

            love.graphics.setFont(fontButton)
            drawTextWithBorder(buttonText, textX, textY, fontButton, {1,1,1}, {0,0,0}, 1)

        end
    end

end

function selectCharacter.mousepressed(x, y, button)
    efeitoSonoro:play("sounds/soundeffect/click.wav")

    if button == 1 then
        if mostrarRegras then
            if button == 1 then 
                mostrarRegras = false
                return
            end
        end
        
        for i = 1, visiblePlayers do
            local p = playerData[i]
            if p.leftArrow and x > p.leftArrow.x and x < p.leftArrow.x + p.leftArrow.w and y > p.leftArrow.y and y < p.leftArrow.y + p.leftArrow.h then
                p.classIndex = p.classIndex - 1
                if p.classIndex < 1 then p.classIndex = #characterClasses end
                tankTypes[i] = p.classIndex 
                return
            end
            if p.rightArrow and x > p.rightArrow.x and x < p.rightArrow.x + p.rightArrow.w and y > p.rightArrow.y and y < p.rightArrow.y + p.rightArrow.h then
                p.classIndex = p.classIndex + 1
                if p.classIndex > #characterClasses then p.classIndex = 1 end
                tankTypes[i] = p.classIndex 
                return
            end
        end

        for _, btn in ipairs(plusButtons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                visiblePlayers = math.min(visiblePlayers + 1, 4)
                playerData[visiblePlayers] = playerData[visiblePlayers] or { classIndex = 1 }
                tankTypes[visiblePlayers] = playerData[visiblePlayers].classIndex or 1
                return
            end
        end

        if x > buttonRegras.x and x < buttonRegras.x + buttonRegras.width and
        y > buttonRegras.y and y < buttonRegras.y + buttonRegras.height then
            buttonRegras.action()
            return
        end

        local screenWidth, screenHeight = love.graphics.getDimensions()
        local buttonWidth, buttonHeight = screenWidth * 0.2, screenHeight * 0.08
        local buttonSpacing = screenHeight * 0.02
        local buttonX1 = screenWidth * 0.5 - buttonWidth - buttonSpacing * 0.5
        local buttonX2 = screenWidth * 0.5 + buttonSpacing * 0.5
        local buttons = {
            { x = buttonX1, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, action = function()
                selectCharacter.quantidadeJogadores = visiblePlayers
                trocarEstado("mapa1")
            end },
            { x = buttonX2, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, action = function()
                trocarEstado("menu")
            end }
        }

        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.action()
                return
            end
        end
    end
end


return selectCharacter
