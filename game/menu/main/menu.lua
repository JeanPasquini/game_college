local menu = {}

function menu.load(gameState)
    menu.gameState = gameState
    menu.fonte = love.graphics.newFont(40)  -- Fonte maior para o texto dos botões

    -- Dimensões da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Dimensões dos botões
    local buttonWidth = 400
    local buttonHeight = 80
    local buttonSpacing = 20  -- Espaçamento entre os botões

    -- Posição inicial dos botões (centralizada verticalmente)
    local startY = (screenHeight - (4 * buttonHeight + 3 * buttonSpacing)) / 2

    -- Centraliza os botões horizontalmente
    local buttonX = (screenWidth - buttonWidth) / 2

    -- Define os botões do menu
    menu.botoes = {
        { texto = "Jogar", x = buttonX, y = startY, largura = buttonWidth, altura = buttonHeight, acao = function() menu.gameState.estado = "mapa1" end, hover = false },
        { texto = "Opções", x = buttonX, y = startY + buttonHeight + buttonSpacing, largura = buttonWidth, altura = buttonHeight, acao = function() menu.gameState.estado = "opcoes" end, hover = false },
        { texto = "Créditos", x = buttonX, y = startY + 2 * (buttonHeight + buttonSpacing), largura = buttonWidth, altura = buttonHeight, acao = function() menu.gameState.estado = "creditos" end, hover = false },
        { texto = "Sair", x = buttonX, y = startY + 3 * (buttonHeight + buttonSpacing), largura = buttonWidth, altura = buttonHeight, acao = function() love.event.quit() end, hover = false }
    }
end

function menu.update(dt)
    -- Atualizações do menu, se necessário
end

function menu.draw()
    love.graphics.setFont(menu.fonte)
    love.graphics.setBackgroundColor(0, 0, 0.2)  -- Fundo azul escuro

    for _, botao in ipairs(menu.botoes) do
        -- Cor do botão (DodgerBlue normal ou mais escuro no hover)
        if botao.hover then
            love.graphics.setColor(0.06, 0.28, 0.5)  -- DodgerBlue mais escuro
        else
            love.graphics.setColor(0.12, 0.56, 1)  -- DodgerBlue normal
        end

        -- Desenha o botão com bordas arredondadas
        love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura, 10, 10)

        -- Sombra do botão (para um efeito mais moderno)
        love.graphics.setColor(0, 0, 0, 0.5)  -- Preto com 50% de transparência
        love.graphics.rectangle("fill", botao.x + 5, botao.y + 5, botao.largura, botao.altura, 10, 10)

        -- Texto do botão (centralizado e com sombra)
        love.graphics.setColor(1, 1, 1)  -- Texto branco
        love.graphics.printf(botao.texto, botao.x, botao.y + (botao.altura / 2) - 20, botao.largura, "center")
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

function menu.mousemoved(x, y)
    for _, botao in ipairs(menu.botoes) do
        if x > botao.x and x < botao.x + botao.largura and y > botao.y and y < botao.y + botao.altura then
            botao.hover = true
        else
            botao.hover = false
        end
    end
end

return menu