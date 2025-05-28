local selectCharacter = {}
local visiblePlayers = 2
local plusButtons = {}
local fontPlayerName
local playerData = {}

local arrowLeftImage = love.graphics.newImage("resources/icons/arrow_left.png")
local arrowRightImage = love.graphics.newImage("resources/icons/arrow_right.png")

local tankImage = love.graphics.newImage("resources/sprites/tank/tank.png") -- imagem do tanque comum

-- Cores diferentes para cada classe (r,g,b,a)
local classColors = {
    {1, 1, 1, 1}, 
    {1, 0.4, 0.4, 1},    
    {0.5, 0.9, 0.9, 1},    
    {0.3, 0.5, 1, 1} 
}

local characterClasses = {
    { name = "Tanque Comum", vida = 150, dano = 20, salto = 2 },
    { name = "Tanque Goliath X", vida = 250, dano = 15, salto = 1 },
    { name = "Tanque Lightning Viper", vida = 150, dano = 15, salto = 4 },
    { name = "Tanque Doombringer", vida = 100, dano = 30, salto = 1 }
}

local classIcons = {
    love.graphics.newImage("resources/icons/icon_tanque_comum.png"),
    love.graphics.newImage("resources/icons/icon_tanque_goliath_x.png"),
    love.graphics.newImage("resources/icons/icon_tanque_lightning_viper.png"),
    love.graphics.newImage("resources/icons/icon_tanque_doombringer.png"),
}


-- Variável global para guardar o tipo do tanque escolhido por jogador
tankTypes = {}  -- Exemplo: tankTypes[1] = 1 (Tanque Comum do jogador 1)

function selectCharacter.load(gameState, quantidadeJogadores)
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
        tankTypes[i] = 1 -- Inicializa todos com tanque comum (tipo 1)
    end
end

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scale = math.max(windowWidth / bgWidth, windowHeight / bgHeight)
    love.graphics.draw(background, 0, 0, 0, scale, scale)
end

function selectCharacter.update(dt)
    -- Aqui pode colocar lógica de update se necessário
end

local iconVida = love.graphics.newImage("resources/icons/fc659.png")
local iconDano = love.graphics.newImage("resources/icons/fc998.png")
local iconSalto = love.graphics.newImage("resources/icons/fc658.png")

function selectCharacter.draw()
    drawBackground()

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
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(nameText, x + (squareSize - textWidth) / 2, y - 28)

            -- Desenha a imagem do tanque com cor da classe
            local scale = 2.5
            local w, h = tankImage:getWidth(), tankImage:getHeight()
            local iconX = x + (squareSize - w * scale) / 2
            local iconY = y + (squareSize - h * scale) / 2

            local color = classColors[p.classIndex] or {1, 1, 1, 1} -- fallback branco
            love.graphics.setColor(color)
            love.graphics.draw(tankImage, iconX, iconY, 0, scale, scale)
            love.graphics.setColor(1, 1, 1, 1) -- resetar cor

            -- Ícones e textos de vida, dano, salto
            local statusY = y + squareSize + 10
            local statusX = x
            local boxWidth, boxHeight = squareSize, 36
            local padding = 8
            local iconSizeSmall = 28
            local textOffset = iconSizeSmall + 14

            local statusList = {
                { icon = iconVida, text = "Vida :     " .. class.vida },
                { icon = iconDano, text = "Dano :      " .. class.dano },
                { icon = iconSalto, text = "Salto:       " .. class.salto },
            }

            for j, status in ipairs(statusList) do
                local boxY = statusY + (j - 1) * (boxHeight + 10)
                love.graphics.setColor(0.18, 0.12, 0.19, 0.85)
                love.graphics.rectangle("fill", statusX, boxY, boxWidth, boxHeight, 8)
                love.graphics.setColor(1, 1, 0.6)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", statusX, boxY, boxWidth, boxHeight, 8)

                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(status.icon, statusX + padding, boxY + (boxHeight - iconSizeSmall) / 2, 0, iconSizeSmall / status.icon:getWidth(), iconSizeSmall / status.icon:getHeight())
                love.graphics.print(status.text, statusX + padding + textOffset, boxY + (boxHeight - fontPlayerName:getHeight()) / 2)
            end

            -- Setas para trocar classe
            local arrowScale = 3.5
            local arrowSize = arrowLeftImage:getWidth() * arrowScale
            local arrowY = y + 130

            p.leftArrow = { x = x - 42, y = arrowY, w = arrowSize, h = arrowLeftImage:getHeight() * arrowScale, index = i, dir = -1 }
            p.rightArrow = { x = x + squareSize, y = arrowY, w = arrowSize, h = arrowLeftImage:getHeight() * arrowScale, index = i, dir = 1 }

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(arrowLeftImage, p.leftArrow.x, p.leftArrow.y, 0, arrowScale, arrowScale)
            love.graphics.draw(arrowRightImage, p.rightArrow.x, p.rightArrow.y, 0, arrowScale, arrowScale)

        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(love.graphics.newFont(36))
            love.graphics.printf("+", x, y + squareSize / 2 - 18, squareSize, "center")
            table.insert(plusButtons, { x = x, y = y, width = squareSize, height = squareSize, slot = i })
        end

                -- Desenhar o ícone da classe no canto superior direito do quadrado principal
        if i <= visiblePlayers then
            
            local p = playerData[i]
            local iconSize = 48
            local iconX = x + squareSize - iconSize - 10
            local iconY = y + 10

            -- Desenha o fundo arredondado do ícone
            love.graphics.setColor(0.18, 0.12, 0.19, 0.85) -- Cor de fundo escura
            love.graphics.rectangle("fill", iconX, iconY, iconSize, iconSize, 12) -- Arredondado 12

            -- Desenha a borda
            love.graphics.setColor(1, 1, 0.6)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", iconX, iconY, iconSize, iconSize, 12)

            -- Desenha o ícone da classe dentro da borda
            local iconImage = classIcons[p.classIndex]
            local iconScale = iconSize / iconImage:getWidth() * 0.7
            local iconOffset = (iconSize - iconImage:getWidth() * iconScale) / 2

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(iconImage, iconX + iconOffset, iconY + iconOffset, 0, iconScale, iconScale)
        end

    end

    -- Botões Jogar e Voltar
    local buttonWidth, buttonHeight = screenWidth * 0.2, screenHeight * 0.08
    local buttonSpacing = screenHeight * 0.02
    local buttonX1 = screenWidth * 0.5 - buttonWidth - buttonSpacing * 0.5
    local buttonX2 = screenWidth * 0.5 + buttonSpacing * 0.5

    local buttons = {
        { x = buttonX1, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, text = "JOGAR", action = function()
            selectCharacter.quantidadeJogadores = visiblePlayers
            trocarEstado("mapa1")
        end },
        { x = buttonX2, y = screenHeight * 0.85, width = buttonWidth, height = buttonHeight, text = "VOLTAR", action = function()
            trocarEstado("menu")
        end }
    }

    for _, btn in ipairs(buttons) do
        local mx, my = love.mouse.getPosition()
        local hover = mx > btn.x and mx < btn.x + btn.width and my > btn.y and my < btn.y + btn.height
        love.graphics.setColor(hover and {0.42, 0.7, 0.42} or {0.29, 0.5, 0.29})
        love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height)
        love.graphics.setColor(1, 1, 0.6)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 15))
        local textWidth = love.graphics.getFont():getWidth(btn.text)
        love.graphics.print(btn.text, btn.x + (btn.width - textWidth) / 2, btn.y + (btn.height - love.graphics.getFont():getHeight()) / 2)
    end
end

function selectCharacter.mousepressed(x, y)
    for i = 1, visiblePlayers do
        local p = playerData[i]
        if p.leftArrow and x > p.leftArrow.x and x < p.leftArrow.x + p.leftArrow.w and y > p.leftArrow.y and y < p.leftArrow.y + p.leftArrow.h then
            p.classIndex = p.classIndex - 1
            if p.classIndex < 1 then p.classIndex = #characterClasses end
            tankTypes[i] = p.classIndex -- Atualiza o tipo do tanque na variável global
            return
        end
        if p.rightArrow and x > p.rightArrow.x and x < p.rightArrow.x + p.rightArrow.w and y > p.rightArrow.y and y < p.rightArrow.y + p.rightArrow.h then
            p.classIndex = p.classIndex + 1
            if p.classIndex > #characterClasses then p.classIndex = 1 end
            tankTypes[i] = p.classIndex -- Atualiza o tipo do tanque na variável global
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

    -- Checa clique nos botões Jogar e Voltar
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

return selectCharacter
