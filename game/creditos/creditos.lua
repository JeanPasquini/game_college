local creditos = {}

function creditos.load(gameState)
    creditos.gameState = gameState
    creditos.fonte = love.graphics.newFont(40)
    creditos.fontePequena = love.graphics.newFont(20)

    -- Dimensões da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Dimensões do botão "Voltar"
    local buttonWidth = 400
    local buttonHeight = 80

    -- Centraliza o botão "Voltar" horizontalmente
    local buttonX = (screenWidth - buttonWidth) / 2

    -- Botão "Voltar" para retornar ao menu
    creditos.botaoVoltar = {
        texto = "Voltar",
        x = buttonX,
        y = 700,
        largura = buttonWidth,
        altura = buttonHeight,
        acao = function() creditos.gameState.estado = "menu" end,
        hover = false
    }
end

function creditos.update(dt)
    -- Atualizações da tela de créditos, se necessário
end

function creditos.draw()
    -- Fundo da tela de créditos
    love.graphics.setBackgroundColor(0, 0, 0.2)  -- Azul escuro

    -- Título
    love.graphics.setFont(creditos.fonte)
    love.graphics.setColor(1, 1, 1)  -- Texto branco
    love.graphics.printf("Créditos", 0, 50, love.graphics.getWidth(), "center")

    -- Texto dos créditos
    love.graphics.setFont(creditos.fonte)
    love.graphics.printf("Desenvolvido por:\n\n Menus e Som:\nFilipi Carvalho Biazoto\n\nGameplay e Estrutura:\nJean Pasquini\n\nDesign e Art\n Amanda\n\nAgradecimentos: Dr Prof José Tarcísio", 0, 100, love.graphics.getWidth(), "center")

    -- Botão "Voltar" (estilo igual ao do menu)
    if creditos.botaoVoltar.hover then
        love.graphics.setColor(0.06, 0.28, 0.5)  -- DodgerBlue mais escuro (hover)
    else
        love.graphics.setColor(0.12, 0.56, 1)  -- DodgerBlue normal
    end

    -- Desenha o botão com bordas arredondadas
    love.graphics.rectangle("fill", creditos.botaoVoltar.x, creditos.botaoVoltar.y, creditos.botaoVoltar.largura, creditos.botaoVoltar.altura, 10, 10)

    -- Sombra do botão (para um efeito mais moderno)
    love.graphics.setColor(0, 0, 0, 0.5)  -- Preto com 50% de transparência
    love.graphics.rectangle("fill", creditos.botaoVoltar.x + 5, creditos.botaoVoltar.y + 5, creditos.botaoVoltar.largura, creditos.botaoVoltar.altura, 10, 10)

    -- Texto do botão (centralizado e com sombra)
    love.graphics.setColor(1, 1, 1)  -- Texto branco
    love.graphics.printf(creditos.botaoVoltar.texto, creditos.botaoVoltar.x, creditos.botaoVoltar.y + (creditos.botaoVoltar.altura / 2) - 20, creditos.botaoVoltar.largura, "center")
end

function creditos.mousepressed(x, y, button)
    if button == 1 then
        if x > creditos.botaoVoltar.x and x < creditos.botaoVoltar.x + creditos.botaoVoltar.largura and
           y > creditos.botaoVoltar.y and y < creditos.botaoVoltar.y + creditos.botaoVoltar.altura then
            creditos.botaoVoltar.acao()  -- Volta ao menu
        end
    end
end

function creditos.mousemoved(x, y)
    -- Verifica se o mouse está sobre o botão "Voltar"
    if x > creditos.botaoVoltar.x and x < creditos.botaoVoltar.x + creditos.botaoVoltar.largura and
       y > creditos.botaoVoltar.y and y < creditos.botaoVoltar.y + creditos.botaoVoltar.altura then
        creditos.botaoVoltar.hover = true
    else
        creditos.botaoVoltar.hover = false
    end
end

return creditos