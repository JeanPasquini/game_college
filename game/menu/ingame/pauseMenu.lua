local pauseMenu = {}

pauseMenu.isVisible = false
local selectedOption = 1
local mapaAtual

local fontRegular = love.graphics.newFont("font/PressStart2P-Regular.ttf", 14)
local fontTitle = love.graphics.newFont("font/PressStart2P-Regular.ttf", 24)

local options = {
    {
        label = "VOLTAR",
        action = function() pauseMenu.isVisible = false end
    },
    {
        label = "RECOMEÇAR",
        action = function()
            pauseMenu.restartGame() 
            musica:changeMusicGradually("sounds/soundtrack/mapa.wav")
        end
    },
    {
        label = "MENU",
        action = function()
            pauseMenu.isVisible = false
            musica:changeMusicGradually("sounds/soundtrack/main.wav")
            trocarEstado("menu")
        end
    }
}

function pauseMenu.setMapa(mapa)
    mapaAtual = mapa
end

function pauseMenu.restartGame()
    pauseMenu.isVisible = false
    mapaAtual.restart()
end

function pauseMenu.toggle()
    pauseMenu.isVisible = not pauseMenu.isVisible
    
    if pauseMenu.isVisible then
        efeitoSonoro:play("sounds/soundeffect/menuin.wav")
    else
        efeitoSonoro:play("sounds/soundeffect/menuout.wav")
    end
end

function pauseMenu.draw()
    
    if not pauseMenu.isVisible then return end

    local width, height = love.graphics.getDimensions()
    local mx, my = love.mouse.getPosition()

    local buttonWidth = width * 0.2
    local buttonHeight = height * 0.08
    local spacing = height * 0.02
    local startY = (height - (#options * buttonHeight + (#options - 1) * spacing)) / 2
    local buttonX = (width - buttonWidth) / 2

    local menuBorderWidth = buttonWidth + 40
    local menuBorderHeight = (#options * buttonHeight + (#options - 1) * spacing) + 40
    local menuBorderX = (width - menuBorderWidth) / 2
    local menuBorderY = startY - 20

    love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
    love.graphics.rectangle("fill", menuBorderX, menuBorderY, menuBorderWidth, menuBorderHeight)

    love.graphics.setColor(1, 1, 0)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", menuBorderX, menuBorderY, menuBorderWidth, menuBorderHeight)

    love.graphics.setFont(fontTitle)
    local text = "PAUSE"
    local textWidth = fontTitle:getWidth(text)
    local textHeight = fontTitle:getHeight()
    local textX = (width - textWidth) / 2
    local textY = startY - 50

    drawTextWithBorder(text, textX, textY, fontTitle, {1, 1, 1}, {0, 0, 0}, 1)


    love.graphics.setFont(fontRegular)

    for i, option in ipairs(options) do
        local y = startY + (i - 1) * (buttonHeight + spacing)

        local isHovered = mx >= buttonX and mx <= buttonX + buttonWidth and my >= y and my <= y + buttonHeight

        if isHovered then
            love.graphics.setColor(0.42, 0.7, 0.42) 
        else
            love.graphics.setColor(0.29, 0.5, 0.29) 
        end

        love.graphics.rectangle("fill", buttonX, y, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 0.6)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", buttonX, y, buttonWidth, buttonHeight)
        local fontButton = love.graphics.newFont("font/PressStart2P-Regular.ttf", 15)
        love.graphics.setFont(fontButton) 
        local text = option.label
        local textWidth = fontButton:getWidth(text)
        local textHeight = fontButton:getHeight()

        local textX = buttonX + (buttonWidth - textWidth) / 2
        local textY = y + (buttonHeight / 2) - (textHeight / 2)

        drawTextWithBorder(text, textX, textY, fontButton, {1, 1, 1}, {0, 0, 0}, 1)

    end
end

function pauseMenu.keypressed(key)
if not pauseMenu.isVisible then return end

end

function pauseMenu.mousepressed(x, y, button)
    efeitoSonoro:play("sounds/soundeffect/click.wav")
    if button == 1 then
        local width, height = love.graphics.getDimensions()
        local bx, by, bw, bh = width - 110, 10, 100, 40

        if x >= bx and x <= bx + bw and y >= by and y <= by + bh then
            pauseMenu.toggle()
            return
        end

        if not pauseMenu.isVisible then return end

        local buttonWidth = width * 0.2
        local buttonHeight = height * 0.08
        local spacing = height * 0.02
        local startY = (height - (#options * buttonHeight + (#options - 1) * spacing)) / 2
        local buttonX = (width - buttonWidth) / 2

        for i, option in ipairs(options) do
            local by = startY + (i - 1) * (buttonHeight + spacing)
            if x >= buttonX and x <= buttonX + buttonWidth and y >= by and y <= by + buttonHeight then
                selectedOption = i
                option.action()
                return
            end
        end
    end
end

return pauseMenu
