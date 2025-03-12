local opcoes = {}

function opcoes.load(gameState)
    opcoes.gameState = gameState
    opcoes.fonte = love.graphics.newFont(40)
    opcoes.fontePequena = love.graphics.newFont(20)

    -- Dimensões da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Dimensões do botão "Voltar"
    local buttonWidth = 400
    local buttonHeight = 80

    -- Centraliza o botão "Voltar" horizontalmente
    local buttonX = (screenWidth - buttonWidth) / 2

    -- Botão "Voltar" para retornar ao menu
    opcoes.botaoVoltar = {
        texto = "Voltar",
        x = buttonX,
        y = 700,
        largura = buttonWidth,
        altura = buttonHeight,
        acao = function() opcoes.gameState.estado = "menu" end,
        hover = false
    }

    -- Carrega o som de fundo
    local success, som = pcall(love.audio.newSource, "som-de-fundo.mp3", "stream")
    if success then
        opcoes.som = som
        opcoes.som:setLooping(true)  -- Faz o som de fundo repetir continuamente
        opcoes.som:play()  -- Inicia o som de fundo
    else
        print("Erro: Arquivo de som-de-fundo não encontrado! Verifique o nome e a extensão do arquivo.")
        opcoes.som = nil
    end

    -- Define o volume inicial (0 a 1)
    opcoes.volume = 0.2
    love.audio.setVolume(opcoes.volume)
end

function opcoes.update(dt)
    -- Aumenta ou diminui o volume com as teclas + e -
    if love.keyboard.isDown("kp+") then
        opcoes.volume = math.min(opcoes.volume + 0.1 * dt, 1.0)  -- Aumenta o volume (máximo 1.0)
        love.audio.setVolume(opcoes.volume)
    elseif love.keyboard.isDown("kp-") then
        opcoes.volume = math.max(opcoes.volume - 0.1 * dt, 0.0)  -- Diminui o volume (mínimo 0.0)
        love.audio.setVolume(opcoes.volume)
    end
end

function opcoes.draw()
    -- Fundo da tela de opções
    love.graphics.setBackgroundColor(0, 0, 0.2)  -- Fundo escuro

    -- Título
    love.graphics.setFont(opcoes.fonte)
    love.graphics.setColor(1, 1, 1)  -- Texto branco
    love.graphics.printf("Opções", 0, 100, love.graphics.getWidth(), "center")
    
    love.graphics.setFont(opcoes.fonte)
    love.graphics.printf("Controle o som com (+) e (-)", 0, 240, love.graphics.getWidth(), "center")

    -- Exibe o volume atual na tela
    love.graphics.setFont(opcoes.fonte)
    love.graphics.printf("Volume: " .. tostring(math.floor(opcoes.volume * 100)) .. "%", 0, 300, love.graphics.getWidth(), "center")

    -- Botão "Voltar" (estilo igual ao do menu)
    if opcoes.botaoVoltar.hover then
        love.graphics.setColor(0.06, 0.28, 0.5)  -- DodgerBlue mais escuro (hover)
    else
        love.graphics.setColor(0.12, 0.56, 1)  -- DodgerBlue normal
    end

    -- Desenha o botão com bordas arredondadas
    love.graphics.rectangle("fill", opcoes.botaoVoltar.x, opcoes.botaoVoltar.y, opcoes.botaoVoltar.largura, opcoes.botaoVoltar.altura, 10, 10)

    -- Sombra do botão (para um efeito mais moderno)
    love.graphics.setColor(0, 0, 0, 0.5)  -- Preto com 50% de transparência
    love.graphics.rectangle("fill", opcoes.botaoVoltar.x + 5, opcoes.botaoVoltar.y + 5, opcoes.botaoVoltar.largura, opcoes.botaoVoltar.altura, 10, 10)

    -- Texto do botão (centralizado e com sombra)
    love.graphics.setColor(1, 1, 1)  -- Texto branco
    love.graphics.printf(opcoes.botaoVoltar.texto, opcoes.botaoVoltar.x, opcoes.botaoVoltar.y + (opcoes.botaoVoltar.altura / 2) - 20, opcoes.botaoVoltar.largura, "center")
end

function opcoes.mousepressed(x, y, button)
    if button == 1 then
        if x > opcoes.botaoVoltar.x and x < opcoes.botaoVoltar.x + opcoes.botaoVoltar.largura and
           y > opcoes.botaoVoltar.y and y < opcoes.botaoVoltar.y + opcoes.botaoVoltar.altura then
            opcoes.botaoVoltar.acao()  -- Volta ao menu
        end
    end
end

function opcoes.mousemoved(x, y)
    -- Verifica se o mouse está sobre o botão "Voltar"
    if x > opcoes.botaoVoltar.x and x < opcoes.botaoVoltar.x + opcoes.botaoVoltar.largura and
       y > opcoes.botaoVoltar.y and y < opcoes.botaoVoltar.y + opcoes.botaoVoltar.altura then
        opcoes.botaoVoltar.hover = true
    else
        opcoes.botaoVoltar.hover = false
    end
end

return opcoes