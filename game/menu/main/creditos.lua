local creditos = {}

function creditos.load(gameState)
    creditos.gameState = gameState
    creditos.fonte = love.graphics.newFont(40)
    creditos.fontePequena = love.graphics.newFont(20)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local buttonWidth = 400
    local buttonHeight = 80

    local buttonX = (screenWidth - buttonWidth) / 2

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
end

function creditos.draw()
    love.graphics.setBackgroundColor(0, 0, 0.2) 

    love.graphics.setFont(creditos.fonte)
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf("Créditos", 0, 50, love.graphics.getWidth(), "center")

    love.graphics.setFont(creditos.fonte)
    love.graphics.printf("Desenvolvido por:\n\n Menus e Som:\nFilipi Carvalho Biazoto\n\nGameplay e Estrutura:\nJean Pasquini\n\nDesign e Art\n Amanda\n\nAgradecimentos: Dr Prof José Tarcísio", 0, 100, love.graphics.getWidth(), "center")

    if creditos.botaoVoltar.hover then
        love.graphics.setColor(0.06, 0.28, 0.5)
    else
        love.graphics.setColor(0.12, 0.56, 1)
    end

    love.graphics.rectangle("fill", creditos.botaoVoltar.x, creditos.botaoVoltar.y, creditos.botaoVoltar.largura, creditos.botaoVoltar.altura, 10, 10)

    love.graphics.setColor(0, 0, 0, 0.5) 
    love.graphics.rectangle("fill", creditos.botaoVoltar.x + 5, creditos.botaoVoltar.y + 5, creditos.botaoVoltar.largura, creditos.botaoVoltar.altura, 10, 10)

    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf(creditos.botaoVoltar.texto, creditos.botaoVoltar.x, creditos.botaoVoltar.y + (creditos.botaoVoltar.altura / 2) - 20, creditos.botaoVoltar.largura, "center")
end

function creditos.mousepressed(x, y, button)
    if button == 1 then
        if x > creditos.botaoVoltar.x and x < creditos.botaoVoltar.x + creditos.botaoVoltar.largura and
           y > creditos.botaoVoltar.y and y < creditos.botaoVoltar.y + creditos.botaoVoltar.altura then
            creditos.botaoVoltar.acao() 
        end
    end
end

function creditos.mousemoved(x, y)
    if x > creditos.botaoVoltar.x and x < creditos.botaoVoltar.x + creditos.botaoVoltar.largura and
       y > creditos.botaoVoltar.y and y < creditos.botaoVoltar.y + creditos.botaoVoltar.altura then
        creditos.botaoVoltar.hover = true
    else
        creditos.botaoVoltar.hover = false
    end
end

return creditos