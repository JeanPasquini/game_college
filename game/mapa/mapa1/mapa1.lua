local Objeto = require("mapa.library.objeto") 
local Agua = require("mapa.library.agua") 
local mapa1 = {}
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")
local functionAgua = require("mapa.mapa1.functions.agua") 
local functionObjeto = require("mapa.mapa1.functions.objeto") 
local functionProjetile = require("mapa.mapa1.functions.projectile") 

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

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Turno: Player " .. turno, 10, 10)

    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.circle("fill", love.graphics.getWidth() / 2, 60, 40)

    love.graphics.setColor(255, 255, 255)
    love.graphics.arc("fill", love.graphics.getWidth() / 2, 60, 40, -math.pi / 2, -math.pi / 2 + (tempoRestante / tempoTurno) * (2 * math.pi))

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont("font/PressStart2P-Regular.ttf", 16))
    love.graphics.printf(string.format("%.1f", tempoRestante), 0, 52, love.graphics.getWidth(), "center")

    if player1 then
        love.graphics.setColor(1, 1, 1)
        drawLifeBar(player1)
    end

    if player2 then
        love.graphics.setColor(1, 1, 1)
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
        mensagemExibida = true
        tempoIniciado = false
    elseif (player2 and not player2.visible) or (player2 and player2.life == 0) then
        textoMensagem = "Player 1 venceu!"
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
        textoMensagem = "Vez de Player " .. turno
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
    if not selecionandoSpawn then
        atualizarTempo(dt)
        verificarVitoria()
        verificarTrocaDeTurno()
        controlarJogador(dt)
        atualizarJogadores(dt)
        verificarColisoes()
    end
end

-- Draw Principal
function mapa1.draw()
    love.graphics.setColor(1, 1, 1)
    drawBackground()
    drawObjects()
    drawPlayers()

    if not selecionandoSpawn then
        drawHud()
    end
    
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
