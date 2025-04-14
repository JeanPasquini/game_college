local Objeto = require("mapa.library.objeto") 
local Agua = require("mapa.library.agua") 
local mapa1 = {}
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")
local functionAgua = require("mapa.mapa1.functions.agua") 
local functionObjeto = require("mapa.mapa1.functions.objeto") 
local functionProjetile = require("mapa.mapa1.functions.projectile") 
local Camera = require("mapa.mapa1.functions.cam")

local camera = Camera.new(1920, 1080, 1.2)  -- A câmera será limitada à resolução 1920x1080 com zoom 1.2


local player1
local player2
local turno = 1 
local objetosMapa1 = {}
local aguasMapa1 = {}
local tempoIniciado = false
local tempoTurno = 20
local tempoRestante = tempoTurno

local selecionandoPlayer
local selecionandoSpawn

local lifeImages = {}

for i = 0, 5 do
    lifeImages[i] = love.graphics.newImage("resources/sprites/lifebar/sprite_" .. i .. ".png")
end

function mapa1.load(gameState)
    
    musica:changeMusicGradually("sounds/soundtrack/mapa.ogg")
    selecionandoSpawn = true
    selecionandoPlayer = true

    mapa1.gameState = gameState
    mapa1.debugAtivo = false
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

--------------------------------------------------------------------------------------------------------------------

-- Draws Area

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scaleX = windowWidth / bgWidth
    local scaleY = windowHeight / bgHeight
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
    if player1 and player1.visible then
        player1:draw()
    end
    if player2 and player2.visible then
        player2:draw()
    end
end

function drawHud()
    debug.draw(mapa1.debugAtivo, player1)
    debug.draw(mapa1.debugAtivo, player2)

    local centerX, centerY = love.graphics.getWidth() / 2, 60
    local radius = 40

    -- Fundo do contador mais bonito
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.circle("fill", centerX, centerY, radius + 6)

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.circle("fill", centerX, centerY, radius)

    -- Arco de tempo
    love.graphics.setColor(0.8, 0.3, 0.3)
    love.graphics.arc("fill", centerX, centerY, radius, -math.pi / 2, -math.pi / 2 + (tempoRestante / tempoTurno) * (2 * math.pi))

    -- Texto do tempo
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 16))
    love.graphics.printf(string.format("%.1f", tempoRestante), 0, centerY - 8, love.graphics.getWidth(), "center")

    -- Texto do turno embaixo do contador
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 10))
    love.graphics.printf(turno, 0, centerY + 40, love.graphics.getWidth(), "center")

    -- Barras de vida
    if player1 then
        drawLifeBar(player1)
    end

    if player2 then
        drawLifeBar(player2)
    end

    love.graphics.setColor(1, 1, 1)
end


function drawMessage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 60))
    love.graphics.printf(textoMensagem, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

--------------------------------------------------------------------------------------------------------------------

-- Function Areas
function drawLifeBar(player)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local lifeImage = lifeImages[player.life]

    if lifeImage then
        local scale = 2 
        local imageWidth = lifeImage:getWidth() * scale
        local posY = 20 

        if player == player1 then
            local posX = (windowWidth / 4) - (imageWidth / 2)
            love.graphics.draw(lifeImage, posX, posY, 0, scale, scale)
        elseif player == player2 then
            local posX = (3 * windowWidth / 4) - (imageWidth / 2)
            love.graphics.draw(lifeImage, posX, posY, 0, scale, scale)
        end
    end
end

local function atualizarTempo(dt)
    if tempoIniciado then
        tempoRestante = tempoRestante - dt
    end
end

local function verificarVitoria()
    if (player1 and not player1.visible) or (player1 and player1.life == 0) then
        textoMensagem = "Player 2 venceu!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
    elseif (player2 and not player2.visible) or (player2 and player2.life == 0) then
        textoMensagem = "Player 1 venceu!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
    end
end

local function verificarTrocaDeTurno()
    if tempoRestante <= 0 then
        turno = (turno == 1) and 2 or 1
        player1.disparou = false
        player2.disparou = false
        tempoRestante = tempoTurno
        tempoIniciado = false

        mensagemExibida = true
        textoMensagem = "Vez de " .. ((turno == 1 and player1.name) or player2.name)
    end
end


local function controlarJogador(dt)
    if turno == 1 and tempoIniciado then
        player1:handleInput(dt)
        player1:updateProjectiles(dt)
        if player1.disparou then
            if tempoRestante > 4 then
                tempoRestante = 4
            end
        end
    elseif turno == 2 and tempoIniciado then
        player2:handleInput(dt)
        player2:updateProjectiles(dt)
        if player2.disparou then
            if tempoRestante > 4 then
                tempoRestante = 4
            end
        end
    end
end

local tempoAposDesaparecimento = 0
local posicaoUltimoProjeteil = nil

local function atualizarCamera(dt)
    local playerAtual = (turno == 1) and player1 or player2
    local projeteis = playerAtual.projectiles
    local ultimoProjetil = projeteis[#projeteis]

    if ultimoProjetil then
        -- Segue o último projétil
        posicaoUltimoProjeteil = { x = ultimoProjetil.x, y = ultimoProjetil.y }
        tempoAposDesaparecimento = 0
        camera:update(dt, ultimoProjetil)
    elseif posicaoUltimoProjeteil and tempoAposDesaparecimento < 2 then
        -- Se projétil desapareceu recentemente, mantém a câmera por 2 segundos
        tempoAposDesaparecimento = tempoAposDesaparecimento + dt
        camera:setPosition(posicaoUltimoProjeteil.x, posicaoUltimoProjeteil.y)
    elseif playerAtual and playerAtual.visible then
        -- Após os 2 segundos, volta a seguir o jogador
        camera:update(dt, playerAtual)
        posicaoUltimoProjeteil = nil
    end
end

function updateMensagem(dt)
    if not mensagemExibida then return end

    if mensagemEstado == "entrando" then
        mensagemX = mensagemX + mensagemVelocidade * dt
        if mensagemX >= (love.graphics.getWidth() / 2 - 150) then
            mensagemX = love.graphics.getWidth() / 2 - 150
            mensagemEstado = "parado"
            mensagemTempo = 0
        end

    elseif mensagemEstado == "parado" then
        mensagemTempo = mensagemTempo + dt
        if mensagemTempo >= mensagemDuracaoParado then
            mensagemEstado = "saindo"
        end

    elseif mensagemEstado == "saindo" then
        mensagemX = mensagemX - mensagemVelocidade * dt
        if mensagemX < -400 then
            mensagemExibida = false
        end
    end
end




local function atualizarJogadores(dt)
    player1:applyPhysics(dt)
    player2:applyPhysics(dt)
    player1:lifePlayer(dt)
    player2:lifePlayer(dt)
end

local function verificarColisoes()
    functionObjeto.handleCollisions(player1, objetosMapa1)
    functionObjeto.handleCollisions(player2, objetosMapa1)
    functionAgua.handleCollisionsAgua(player1, aguasMapa1)
    functionAgua.handleCollisionsAgua(player2, aguasMapa1)
    functionProjetile.handleProjectileCollisions({player1, player2}, objetosMapa1)
end

--------------------------------------------------------------------------------------------------------------------

-- Função principal
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
        updateMensagem(dt)
    end
end

-- Draw Principal
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
        love.graphics.pop() -- Restaura o sistema de coordenadas
    end

    -- Elementos fixos na tela (HUD)
    drawHud()

    if mensagemExibida then
        drawMessage()
    end
end


--------------------------------------------------------------------------------------------------------------------

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

function mapa1.mousepressed(x, y, button)
    if selecionandoSpawn and button == 1 then
        if selecionandoPlayer then
            player1 = Player.new(x, y, "1")
            selecionandoPlayer = false
        else
            player2 = Player.new(x, y, "2")
            selecionandoSpawn = false
        end
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
