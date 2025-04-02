local Objeto = require("mapa.library.objeto") 
local Agua = require("mapa.library.agua") 
local mapa1 = {}
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")
local Rules = require("mapa.mapa1.rules") 

local player1
local player2
local turno = 1 
local objetosMapa1 = {}
local aguasMapa1 = {}
local tempoIniciado = false -- Flag para verificar se o tempo começou
local tempoTurno = 20 -- Tempo do turno em segundos
local tempoRestante = tempoTurno

function mapa1.load(gameState)
    mapa1.gameState = gameState
    mapa1.debugAtivo = false
    config.load()
    debug.load() 
 
    background = love.graphics.newImage("resources/backgrounds/background5.png")
    
    player1 = Player.new(1100, 100, "1")
    player2 = Player.new(200, 100, "2") 
    
    for _, objeto in ipairs(config.objetos) do
        table.insert(objetosMapa1, Objeto.new(objeto.x, objeto.y, objeto.valorImagem))
    end
    
    for _, agua in ipairs(config.aguas) do
        table.insert(aguasMapa1, Agua.new(agua.x, agua.y, agua.cor))
    end
end


function mapa1.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scaleX = windowWidth / bgWidth
    local scaleY = windowHeight / bgHeight
    local scale = math.max(scaleX, scaleY)
    
    love.graphics.draw(background, 0, 0, 0, scale, scale)

    for _, objeto in ipairs(objetosMapa1) do
        objeto:draw()
    end
    
    for _, agua in ipairs(aguasMapa1) do
        agua:draw()
    end
    if player1 and player1.visible then
        player1:draw()
    end

    if player2 and player2.visible then
        player2:draw()
    end

    debug.draw(mapa1.debugAtivo, player1)
    debug.draw(mapa1.debugAtivo, player2)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Turno: Player " .. turno, 10, 10)

    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.circle("fill", love.graphics.getWidth() / 2, 60, 40)

    love.graphics.setColor(255, 255, 255)
    love.graphics.arc("fill", love.graphics.getWidth() / 2, 60, 40, -math.pi / 2, -math.pi / 2 + (tempoRestante / tempoTurno) * (2 * math.pi))

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 16))
    love.graphics.printf(string.format("%.1f", tempoRestante), 0, 52, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1)

    if mensagemExibida then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 60))
        love.graphics.printf(textoMensagem, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    -- Quando qualquer tecla for pressionada, o tempo começa
    if not tempoIniciado then
        tempoIniciado = true
        tempoRestante = tempoTurno -- Reinicia o tempo do turno
    end
end



function mapa1.update(dt)
    -- Só atualiza o timer se o tempo já foi iniciado
    if tempoIniciado then
        tempoRestante = tempoRestante - dt
    end

    -- Verifica se algum jogador perdeu
    if player1 and not player1.visible then
        -- Player 2 venceu
        textoMensagem = "Player 2 venceu!"
        mensagemExibida = true
        tempoIniciado = false -- Interrompe o tempo
    elseif player2 and not player2.visible then
        -- Player 1 venceu
        textoMensagem = "Player 1 venceu!"
        mensagemExibida = true
        tempoIniciado = false -- Interrompe o tempo
    end

    -- Quando o tempo acabar, troca o turno e exibe a mensagem de quem é a vez
    if tempoRestante <= 0 then
        turno = (turno == 1) and 2 or 1  -- Alterna entre 1 e 2
        tempoRestante = tempoTurno       -- Reinicia o tempo
        tempoIniciado = false
        mensagemExibida = true  -- Ativa a exibição da mensagem
        textoMensagem = "Vez de Player " .. turno  -- Define o texto da mensagem
    end
    
    -- Controle do jogador
    if turno == 1 and tempoIniciado then
        player1:handleInput(dt)
    elseif turno == 2 and tempoIniciado then
        player2:handleInput(dt)
    end 

    -- Verifica disparos para troca de turno
    if turno == 1 and player1 and player1.visible then
        if player1.disparou then
            player1.disparou = false 
            tempoRestante = 4
        end
    elseif turno == 2 and player2 and player2.visible then
        if player2.disparou then
            player2.disparou = false
            tempoRestante = 4
        end
    end

    -- Atualiza jogadores e física
    player1:applyPhysics(dt)
    player2:applyPhysics(dt)
    player1:updateProjectiles(dt)
    player2:updateProjectiles(dt)
    
    -- Regras de colisão
    Rules.handleCollisions(player1, objetosMapa1)
    Rules.handleCollisionsAgua(player1, aguasMapa1)
    Rules.handleProjectileCollisions(player1, objetosMapa1)
    Rules.handleCollisions(player2, objetosMapa1)
    Rules.handleCollisionsAgua(player2, aguasMapa1)
    Rules.handleProjectileCollisions(player2, objetosMapa1)
end



function mapa1.keypressed(key)
    if key == "'" then
        mapa1.debugAtivo = not mapa1.debugAtivo
    end

    if not tempoIniciado then
        tempoIniciado = true
    end
    if mensagemExibida then
        mensagemExibida = false
    end
end

return mapa1
