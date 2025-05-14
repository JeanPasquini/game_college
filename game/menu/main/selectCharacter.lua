local selectCharacter = {}
local visiblePlayers = 2
local plusButtons = {}
local fontPlayerName

function selectCharacter.load(gameState, quantidadeJogadores)
    selectCharacter.gameState = gameState
    selectCharacter.quantidadeJogadores = quantidadeJogadores
    visiblePlayers = 2
    plusButtons = {}
    fontPlayerName = love.graphics.newFont("font/PressStart2P-Regular.ttf", 14) 
    background = love.graphics.newImage("resources/backgrounds/background5.png")
end

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scaleX = windowWidth / bgWidth
    local scaleY = windowHeight / bgHeight
    local scale = math.max(scaleX, scaleY)
    love.graphics.draw(background, 0, 0, 0, scale, scale)
end


local function getScaledDimensions()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    
    local squareSize = screenWidth * 0.2 
    local margin = screenWidth * 0.05   
    local buttonWidth = screenWidth * 0.2 
    local buttonHeight = screenHeight * 0.08 
    local buttonSpacing = screenHeight * 0.02  
    
    return squareSize, margin, screenWidth, screenHeight, buttonWidth, buttonHeight, buttonSpacing
end

local function drawRoundedRectangle(x, y, width, height, radius)
    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 1, 0.6) -- Amarelo claro
    love.graphics.rectangle("line", x, y, width, height, radius)
end

local function drawShadow(x, y, width, height)
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", x + 5, y + 5, width, height)
end

function selectCharacter.update(dt)

end

function selectCharacter.draw()
    
    drawBackground()

    local squareSize, margin, screenWidth, screenHeight, buttonWidth, buttonHeight, buttonSpacing = getScaledDimensions()
    
    local totalWidth = 4 * (squareSize + margin) - margin
    local offsetX = (screenWidth - totalWidth) / 2

    plusButtons = {}

    for i = 1, 4 do
        local x = (i - 1) * (squareSize + margin) + offsetX
        local y = screenHeight * 0.25  

        drawShadow(x, y, squareSize, squareSize)
        love.graphics.setColor(0.18, 0.12, 0.19) -- #2D1E2F (bordô escuro)
        love.graphics.rectangle("fill", x, y, squareSize, squareSize, 15)
        drawRoundedRectangle(x, y, squareSize, squareSize, 15)

        if i <= visiblePlayers then
            local playerName = "Player " .. i
            love.graphics.setFont(fontPlayerName)
            love.graphics.setColor(1, 1, 1)

            local textWidth = fontPlayerName:getWidth(playerName)
            local textX = x + (squareSize - textWidth) / 2
            local textY = y - (screenHeight * 0.05) 

            love.graphics.print(playerName, textX, textY)

            local imageSize = squareSize - (screenWidth * 0.05) 
            local imageX = x + (squareSize - imageSize) / 2
            local imageY = y + (squareSize - imageSize) / 2

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", imageX, imageY, imageSize, imageSize)
        else
            love.graphics.setColor(0.08, 0.01, 0.10) -- #2D1E2F (bordô escuro)
            love.graphics.rectangle("fill", x, y, squareSize, squareSize, 15)
            drawRoundedRectangle(x, y, squareSize, squareSize, 15)

            love.graphics.setColor(255, 255, 255) -- Amarelo claro
            love.graphics.setFont(love.graphics.newFont(40))
            love.graphics.printf("+", x, y + squareSize / 2 - 20, squareSize, "center")

            table.insert(plusButtons, {
                x = x,
                y = y,
                width = squareSize,
                height = squareSize,
                slot = i
            })
        end
    end

    local buttonX1 = screenWidth * 0.5 - buttonWidth - buttonSpacing * 0.5
    local buttonX2 = screenWidth * 0.5 + buttonSpacing * 0.5

    local buttons = {
        {
            x = buttonX1,
            y = screenHeight * 0.85, 
            width = buttonWidth,
            height = buttonHeight,
            text = "JOGAR",
            action = function()
                selectCharacter.quantidadeJogadores = visiblePlayers
                trocarEstado("mapa1")
            end
        },
        {
            x = buttonX2,
            y = screenHeight * 0.85,
            width = buttonWidth,
            height = buttonHeight,
            text = "VOLTAR",
            action = function()
                trocarEstado("menu")
            end
        }
    }
    
    for _, button in ipairs(buttons) do
        local hover = love.mouse.getX() > button.x and love.mouse.getX() < button.x + button.width and
                    love.mouse.getY() > button.y and love.mouse.getY() < button.y + button.height

        love.graphics.setColor(hover and {0.42, 0.7, 0.42} or {0.29, 0.5, 0.29})
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        love.graphics.setColor(1, 1, 0.6)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(fontPlayerName)

        local textWidth = fontPlayerName:getWidth(button.text)
        local textHeight = fontPlayerName:getHeight(button.text)
        local textX = button.x + (button.width - textWidth) / 2
        local textY = button.y + (button.height - textHeight) / 2

        love.graphics.print(button.text, textX, textY)
    end


    selectCharacter._buttons = buttons
end

function selectCharacter.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end

    if selectCharacter._buttons then
        for _, btn in ipairs(selectCharacter._buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.action()
                return
            end
        end
    end

    for _, plus in ipairs(plusButtons) do
        if x > plus.x and x < plus.x + plus.width and y > plus.y and y < plus.y + plus.height then
            visiblePlayers = math.min(4, visiblePlayers + 1)
            break
        end
    end
end

return selectCharacter
