local Objeto = require("mapa.library.objeto") 
local Agua = require("mapa.library.agua") 
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")
local functionAgua = require("mapa.mapa1.functions.agua") 
local functionObjeto = require("mapa.mapa1.functions.objeto") 
local functionProjetile = require("mapa.mapa1.functions.projectile") 
local Camera = require("mapa.mapa1.functions.cam")

local mapa1 = {}
local camera = Camera.new(1920, 1080, 1.2)

local players = {}
local turno = 1 
local objetosMapa1 = {}
local aguasMapa1 = {}
local tempoIniciado = false
local tempoTurno = 20
local tempoRestante = tempoTurno

local selecionandoPlayer = true
local selecionandoSpawn = true

local lifeImages = {}
for i = 0, 5 do
    lifeImages[i] = love.graphics.newImage("resources/sprites/lifebar/sprite_" .. i .. ".png")
end

function mapa1.load(gameState, quantidadeJogadores)
    
    musica:changeMusicGradually("sounds/soundtrack/mapa.ogg")
    mapa1.gameState = gameState
    mapa1.quantidadeJogadores = quantidadeJogadores
    mapa1.debugAtivo = false
    selecionandoPlayer = true
    selecionandoSpawn = true


    config.load()
    debug.load()

    background = love.graphics.newImage("resources/backgrounds/background5.png")

    for _, objeto in ipairs(config.objetos) do
        table.insert(objetosMapa1, Objeto.new(objeto.x, objeto.y, objeto.valorImagem))
    end

    for _, agua in ipairs(config.aguas) do
        table.insert(aguasMapa1, Agua.new(agua.x, agua.y, agua.cor))
    end

end

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local scaleX = windowWidth / background:getWidth()
    local scaleY = windowHeight / background:getHeight()
    local scale = math.max(scaleX, scaleY)
    love.graphics.draw(background, 0, 0, 0, scale, scale)
end

function drawObjects()
    for _, objeto in ipairs(objetosMapa1) do
        objeto:draw()
    end
    for _, agua in ipairs(aguasMapa1) do
        agua:draw()
    end
end

function drawPlayers()
    for _, player in ipairs(players) do
        if player.visible then
            player:draw()
        end
    end
end

function drawLifeBar(player, index)
    love.graphics.setColor(1, 1, 1)
    local windowWidth = love.graphics.getWidth()
    local lifeImage = lifeImages[player.life]
    if lifeImage then
        local scale = 2
        local imageWidth = lifeImage:getWidth() * scale
        local spacing = windowWidth / (mapa1.quantidadeJogadores + 1)
        local posX = spacing * index - imageWidth / 2
        local posY = 20
        love.graphics.draw(lifeImage, posX, posY, 0, scale, scale)
    end
end

function drawHud()
    for i, player in ipairs(players) do
        drawLifeBar(player, i)
        debug.draw(mapa1.debugAtivo, player)
    end

    local centerX, centerY = love.graphics.getWidth() / 2, 60
    local radius = 40

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.circle("fill", centerX, centerY, radius + 6)

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.circle("fill", centerX, centerY, radius)

    love.graphics.setColor(0.8, 0.3, 0.3)
    love.graphics.arc("fill", centerX, centerY, radius, -math.pi / 2, -math.pi / 2 + (tempoRestante / tempoTurno) * (2 * math.pi))

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 16))
    love.graphics.printf(string.format("%.1f", tempoRestante), 0, centerY - 8, love.graphics.getWidth(), "center")

    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 10))
    love.graphics.printf("Turno: " .. turno, 0, centerY + 40, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    
    -- Adicionando a renderização da mensagem de vitória ou de vez
    if textoMensagem and mensagemExibida == true then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 60))
        love.graphics.printf(textoMensagem, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end


local function atualizarTempo(dt)
    if tempoIniciado then
        tempoRestante = tempoRestante - dt
    end
end

local function verificarVitoria()
    local vivos = {}
    for _, player in ipairs(players) do
        if player.visible and player.life > 0 then
            table.insert(vivos, player)
        end
    end

    if #vivos == 1 then
        textoMensagem = vivos[1].name .. " venceu!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
    elseif #vivos == 0 then
        textoMensagem = "Empate!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
    end
end

local function verificarTrocaDeTurno()
    if tempoRestante <= 0 then
        players[turno].disparou = false
        repeat
            turno = turno % #players + 1
        until players[turno].visible and players[turno].life > 0
        tempoRestante = tempoTurno
        tempoIniciado = false
        mensagemExibida = true
        textoMensagem = "Vez de " .. players[turno].name
    end
end

local function controlarJogador(dt)
    local playerAtual = players[turno]
    if tempoIniciado then
        playerAtual:handleInput(dt)
        playerAtual:updateProjectiles(dt)
        if playerAtual.disparou and tempoRestante > 4 then
            tempoRestante = 4
        end
    end
end

local tempoAposDesaparecimento = 0
local posicaoUltimoProjeteil = nil

local function atualizarCamera(dt)
    local playerAtual = players[turno]
    local projeteis = playerAtual.projectiles
    local ultimoProjetil = projeteis[#projeteis]

    if ultimoProjetil then
        posicaoUltimoProjeteil = { x = ultimoProjetil.x, y = ultimoProjetil.y }
        tempoAposDesaparecimento = 0
        camera:update(dt, ultimoProjetil)
    elseif posicaoUltimoProjeteil and tempoAposDesaparecimento < 2 then
        tempoAposDesaparecimento = tempoAposDesaparecimento + dt
        camera:setPosition(posicaoUltimoProjeteil.x, posicaoUltimoProjeteil.y)
    elseif playerAtual and playerAtual.visible then
        camera:update(dt, playerAtual)
        posicaoUltimoProjeteil = nil
    end
end

local function atualizarJogadores(dt)
    for _, player in ipairs(players) do
        player:applyPhysics(dt)
        player:lifePlayer(dt)
    end
end

local function verificarColisoes()
    for _, player in ipairs(players) do
        functionObjeto.handleCollisions(player, objetosMapa1)
        functionAgua.handleCollisionsAgua(player, aguasMapa1)
    end
    functionProjetile.handleProjectileCollisions(players, objetosMapa1)
end

function mapa1.update(dt)
    for _, agua in ipairs(aguasMapa1) do
        agua:update(dt)
    end

    if not selecionandoSpawn then
        atualizarTempo(dt)
        verificarVitoria()
        verificarTrocaDeTurno()
        controlarJogador(dt)
        atualizarJogadores(dt)
        verificarColisoes()
        atualizarCamera(dt)
    end
end

function mapa1.draw()
    love.graphics.setColor(1, 1, 1)

    if not selecionandoSpawn then
        love.graphics.push()
        love.graphics.scale(camera.zoom)
        love.graphics.translate(-camera.cameraX, -camera.cameraY)
    end

    drawBackground()
    drawObjects()
    drawPlayers()

    if not selecionandoSpawn then
        love.graphics.pop()
        drawHud()
    end
end

local jogadoresContados = 0  -- Contador para acompanhar a quantidade de jogadores


function mapa1.mousepressed(x, y, button)
    if selecionandoSpawn and button == 1 then
        if jogadoresContados < mapa1.quantidadeJogadores then  -- Verifica se ainda podemos adicionar jogadores
            local novoJogadorID = tostring(jogadoresContados + 1)  -- Gera o ID do jogador com base no contador
            local novoJogador = Player.new(x, y, novoJogadorID)  -- Cria o novo jogador
            table.insert(players, novoJogador)  -- Adiciona o jogador na tabela
            jogadoresContados = jogadoresContados + 1  -- Incrementa o contador de jogadores
            
            -- Se o número de jogadores atingiu o máximo, desativa a seleção de spawn
            if jogadoresContados >= mapa1.quantidadeJogadores then
                selecionandoSpawn = false
            end
        end
    end
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

function love.keypressed(key)
    if not selecionandoSpawn then
        if not tempoIniciado then
            tempoIniciado = true
            tempoRestante = tempoTurno
        end
    end
end

return mapa1
