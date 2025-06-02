local Objeto = require("mapa.library.objeto") 
local ObjetoInquebravel = require("mapa.library.objetoInquebravel") 
local ObjetoCenario = require("mapa.library.objetoCenario") 
local Agua = require("mapa.library.agua") 
local config = require("mapa.generator.config")
local debug = require("debug.debug")
local Player = require("player.player")
local functionAgua = require("mapa.mapa1.functions.agua") 
local functionObjeto = require("mapa.mapa1.functions.objeto") 
local functionObjetoInquebravel = require("mapa.mapa1.functions.objetoInquebravel")
local functionProjetile = require("mapa.mapa1.functions.projectile") 
local Camera = require("mapa.mapa1.functions.cam")
local pauseMenu = require("menu.ingame.pauseMenu")

local backgroundFunction = require("mapa.mapa1.functions.background")

local miraInicialAtivada = false


local statusVitoria = false

local mapa1 = {}
local camera = Camera.new(1920, 1080, 1.2)

local players = {}
local turno = 1 
local objetosMapa1 = {}
local objetosInquebravelMapa1 = {}
local objetosCenarioMapa1 = {}
local aguasMapa1 = {}
local tempoIniciado = false
local tempoTurno = 20
local tempoRestante = tempoTurno
local jogadoresContados = 0 
local _quantidadeJogadores = 0


local pixelClouds = {}
local maxPixelClouds = 6

local selecionandoPlayer = true
local selecionandoSpawn = true

tanqueIcons = {
    [1] = love.graphics.newImage("resources/icons/icon_tanque_comum.png"),
    [2] = love.graphics.newImage("resources/icons/icon_tanque_goliath_x.png"),
    [3] = love.graphics.newImage("resources/icons/icon_tanque_lightning_viper.png"),
    [4] = love.graphics.newImage("resources/icons/icon_tanque_doombringer.png")
}


function mapa1.restart()
    turno = 1
    tempoRestante = tempoTurno
    tempoIniciado = false
    mensagemExibida = false
    textoMensagem = nil
    jogadoresContados = 0
    mapa1.quantidadeJogadores = _quantidadeJogadores
    selecionandoPlayer = true
    selecionandoSpawn = true
    statusVitoria = false
    players = {}
    miraInicialAtivada = false

    objetosMapa1 = {}
    objetosInquebravelMapa1 = {}
    objetosCenarioMapa1 = {}
    aguasMapa1 = {}

    for _, objeto in ipairs(config.objetos) do
        table.insert(objetosMapa1, Objeto.new(objeto.x, objeto.y, objeto.valorImagem))
    end

    for _, objetoInquebravel in ipairs(config.objetosInquebravel) do
        table.insert(objetosInquebravelMapa1, ObjetoInquebravel.new(objetoInquebravel.x, objetoInquebravel.y, objetoInquebravel.valorImagem))
    end
    
    for _, objetoCenario in ipairs(config.objetosCenario) do
        table.insert(objetosCenarioMapa1, ObjetoCenario.new(objetoCenario.x, objetoCenario.y, objetoCenario.valorImagem))
    end

    for _, agua in ipairs(config.aguas) do
        table.insert(aguasMapa1, Agua.new(agua.x, agua.y, agua.valorImagem))
    end

    musica:changeMusicGradually("sounds/soundtrack/mapa.wav")
    pauseMenu.setMapa(mapa1)
    if pauseMenu.isVisible then pauseMenu.isVisible = false end
    pixelClouds = {}
    initializePixelClouds()
end


function mapa1.load(gameState, quantidadeJogadores)
    backgroundFunction.load()
    tanqueIcon = love.graphics.newImage("resources/sprites/tank/idleTank.png")
    musica:changeMusicGradually("sounds/soundtrack/mapa.wav")
    mapa1.gameState = gameState
    mapa1.quantidadeJogadores = quantidadeJogadores
    _quantidadeJogadores = quantidadeJogadores
    mapa1.debugAtivo = false
    selecionandoPlayer = true
    selecionandoSpawn = true
    statusVitoria = false
    miraInicialAtivada = false

    config.load()
    debug.load()

    for _, objeto in ipairs(config.objetos) do
        table.insert(objetosMapa1, Objeto.new(objeto.x, objeto.y, objeto.valorImagem))
    end

    for _, agua in ipairs(config.aguas) do
        table.insert(aguasMapa1, Agua.new(agua.x, agua.y, agua.valorImagem))
    end

    for _, objetoInquebravel in ipairs(config.objetosInquebravel) do
        table.insert(objetosInquebravelMapa1, ObjetoInquebravel.new(objetoInquebravel.x, objetoInquebravel.y, objetoInquebravel.valorImagem))
    end

    for _, objetoCenario in ipairs(config.objetosCenario) do
        table.insert(objetosCenarioMapa1, ObjetoCenario.new(objetoCenario.x, objetoCenario.y, objetoCenario.valorImagem))
    end

    pixelClouds = {}
    initializePixelClouds()
    mapa1.restart()
end

function calcularEscala()
    local larguraAtual = love.graphics.getWidth()
    local alturaAtual = love.graphics.getHeight()

    local escalaX = larguraAtual / 1920
    local escalaY = alturaAtual / 1080

    return math.min(escalaX, escalaY)
end

function drawObjects()
    for _, objeto in ipairs(objetosMapa1) do
        objeto:draw()
    end
    for _, objetoInquebravel in ipairs(objetosInquebravelMapa1) do
        objetoInquebravel:draw()
    end
    for _, objetoCenario in ipairs(objetosCenarioMapa1) do
        objetoCenario:draw()
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
    local spacing = love.graphics.getWidth() / (mapa1.quantidadeJogadores + 1)

    local posX = spacing * index
    local posY = 80
    local barWidth = 180        
    local barHeight = 28        
    local border = 4            
    local iconSize = 56      
    local iconX = posX - iconSize - 20  
    local iconY = posY - 8    
    local filledWidth = (math.floor(player.life) / player.maxLife) * barWidth  

    local iconCenterX = iconX + iconSize / 2
    local iconCenterY = iconY + iconSize / 2

    love.graphics.setColor(1, 1, 1, 0.2) 
    love.graphics.rectangle("fill", iconX - 8, iconY - 8, iconSize + 16, iconSize + 16)

    love.graphics.setColor(0.1, 0.1, 0.1)  
    love.graphics.rectangle("fill", iconX, iconY, iconSize, iconSize, 8) 

    love.graphics.setColor(1, 1, 1, 0.1) 
    love.graphics.rectangle("fill", iconX, iconY, iconSize, iconSize, 8)

    local iconImage = tanqueIcons[player.tipoTanque] or tanqueIcons[1]

    if iconImage then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            iconImage,
            iconCenterX,
            iconCenterY,
            0,
            iconSize / iconImage:getWidth() * 0.8,
            iconSize / iconImage:getHeight() * 0.8,
            iconImage:getWidth() / 2,
            iconImage:getHeight() / 2
        )
    end

    love.graphics.setColor(0.7, 0.7, 0.7)  
    love.graphics.rectangle("fill", posX - border, posY - border, barWidth + border * 2, barHeight + border * 2)

    love.graphics.setColor(0.1, 0.1, 0.1) 
    love.graphics.rectangle("fill", posX, posY, barWidth, barHeight)

    local lifePercent = player.life / player.maxLife
    if lifePercent > 0.5 then
        love.graphics.setColor(0.2, 0.6, 0.2)  
    elseif lifePercent > 0.2 then
        love.graphics.setColor(0.8, 0.7, 0.2)  
    else
        love.graphics.setColor(0.8, 0.3, 0.3)  
    end
    love.graphics.rectangle("fill", posX, posY, filledWidth, barHeight)

    love.graphics.setColor(1, 1, 1, 0.2) 
    love.graphics.rectangle("fill", posX, posY, filledWidth, barHeight / 2)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(2)  
    love.graphics.rectangle("line", posX, posY, barWidth, barHeight)

    love.graphics.setColor(1, 1, 1)
    local font = love.graphics.getFont()
    local lifeText = math.floor(player.life) .. " / " .. player.maxLife
    local lifeTextWidth = font:getWidth(lifeText)
    local x = posX + (barWidth - lifeTextWidth) / 2
    local y = posY + barHeight / 2 - font:getHeight() / 2

    drawTextWithBorder(lifeText, x, y, font, {1, 1, 1}, {0, 0, 0}, 1)


    local nameText = "Player " .. player.name
    local font = love.graphics.getFont()
    local nameWidth = font:getWidth(nameText)
    local nameHeight = 22
    local posYText = posY + barHeight + 5
    local textY = posYText + (nameHeight - font:getHeight()) / 2

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", posX, posYText, nameWidth + 15, nameHeight)

    drawTextWithBorder(nameText, posX + 8, textY, font, {1, 1, 1}, {0, 0, 0}, 1)


    love.graphics.setColor(1, 1, 1)
end



function initializePixelClouds()
    for i = 1, maxPixelClouds do
        table.insert(pixelClouds, {
            x = math.random(-300, love.graphics.getWidth()),
            y = math.random(20, 200),
            width = math.random(50, 120),
            height = math.random(20, 50),
            speed = math.random(20, 60),
            color = {0.9, 0.9, 0.9, 0.9}
        })
    end
end

function updatePixelClouds(dt)
    for _, cloud in ipairs(pixelClouds) do
        cloud.x = cloud.x + cloud.speed * dt
        if cloud.x > love.graphics.getWidth() then
            cloud.x = -cloud.width
            cloud.y = math.random(20, 200)
            cloud.width = math.random(50, 120)
            cloud.height = math.random(20, 50)
            cloud.speed = math.random(20, 60)
        end
    end
end

function drawPixelClouds()
    for _, cloud in ipairs(pixelClouds) do
        love.graphics.setColor(cloud.color)

        local x, y = cloud.x, cloud.y
        local w, h = cloud.width, cloud.height

        love.graphics.rectangle("fill", x, y, w, h)

        love.graphics.rectangle("fill", x - 10, y - 10, w + 20, h / 2)

        love.graphics.rectangle("fill", x - 15, y + h - 5, w + 30, h / 3)

        love.graphics.rectangle("fill", x + w - 10, y - 15, 30, 20)
        love.graphics.rectangle("fill", x - 20, y + h / 2, 30, 15)

        love.graphics.rectangle("fill", x + w / 2, y + h, 20, 10)
        love.graphics.rectangle("fill", x - 25, y + h / 3, 20, 15)
    end

    love.graphics.setColor(1, 1, 1)
end

function drawHud()
    for i, player in ipairs(players) do
        drawLifeBar(player, i)
        debug.draw(mapa1.debugAtivo, player)
    end

    local margin = 50 
    local baseX = margin
    local baseY = love.graphics.getHeight() - 210
    local clockRadius = 47  
    local borderThickness = 6
    local centerDotSize = 6
    local handLength = clockRadius - 12
    local handThickness = 4
    local timeRatio = tempoRestante / tempoTurno
    local handAngle = -math.pi / 2 + timeRatio * 2 * math.pi

    local textPadding = 10 
    local textWidth = 240  
    local textHeight = 100  
    local hudWidth = (clockRadius * 2) + textWidth + textPadding * 2  
    local hudHeight = math.max(clockRadius * 2, textHeight) + borderThickness * 2

    love.graphics.setColor(0.15, 0.15, 0.15, 0.9)
    love.graphics.rectangle("fill", baseX, baseY, clockRadius * 2, clockRadius * 2)

    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle("fill", baseX + borderThickness + 6, baseY + borderThickness + 6, (clockRadius - borderThickness - 6) * 2, (clockRadius - borderThickness - 6) * 2)

    love.graphics.setColor(0.1, 0.1, 0.1)
    for i = 0, 3 do
        local angle = i * math.pi / 2
        local x = math.floor(baseX + clockRadius + math.cos(angle) * (clockRadius - 12))
        local y = math.floor(baseY + clockRadius + math.sin(angle) * (clockRadius - 12))
        love.graphics.rectangle("fill", x - 2, y - 2, 4, 4)
    end

    local handX = baseX + clockRadius + math.cos(handAngle) * (handLength - 6)
    local handY = baseY + clockRadius + math.sin(handAngle) * (handLength - 6)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.setLineWidth(handThickness)
    love.graphics.line(baseX + clockRadius, baseY + clockRadius, handX, handY)

    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", baseX + clockRadius - centerDotSize / 2, baseY + clockRadius - centerDotSize / 2, centerDotSize, centerDotSize)

    local textBackgroundX1 = baseX + clockRadius * 2 + textPadding
    local textBackgroundX2 = baseX + clockRadius * 2 + textPadding  
    local textHeight = 40 
    local textWidth = 200  
    local borderThickness = 1 
    local spaceBetween = 10  

    love.graphics.setColor(0.15, 0.15, 0.15, 0.9)
    love.graphics.rectangle("fill", textBackgroundX1, baseY, textWidth, textHeight)  
    love.graphics.rectangle("fill", textBackgroundX2, baseY + textHeight + spaceBetween, textWidth, textHeight)  

    love.graphics.setColor(0.7, 0.7, 0.7)  
    love.graphics.rectangle("line", textBackgroundX1 - borderThickness, baseY - borderThickness, textWidth + borderThickness * 2, textHeight + borderThickness * 2)
    love.graphics.rectangle("line", textBackgroundX2 - borderThickness, baseY + textHeight + spaceBetween - borderThickness, textWidth + borderThickness * 2, textHeight + borderThickness * 2)

    local font16 = love.graphics.newFont("font/PressStart2P-Regular.ttf", 16)
    local font20 = love.graphics.newFont("font/PressStart2P-Regular.ttf", 20)

    local textBaseX1 = textBackgroundX1 + 10
    local tempoColor = (tempoRestante / tempoTurno > 0.3) and {0, 1, 0} or {1, 0, 0}
    love.graphics.setFont(font16)
    drawTextWithBorder(string.format("%.1f s", tempoRestante), textBaseX1, baseY + 20, font16, tempoColor, {0, 0, 0}, 1)

    local textBaseX2 = textBackgroundX2 + 10
    love.graphics.setFont(font20)
    drawTextWithBorder("Round: " .. turno, textBaseX2, baseY + textHeight + spaceBetween + 20, font20, {0.7, 0.7, 0.7}, {0, 0, 0}, 1)

    if textoMensagem and mensagemExibida == true then

        local vivos = {}
        for _, player in ipairs(players) do
            if player.visible and player.life > 0 then
                table.insert(vivos, player)
            end
        end
        local fontTitle = love.graphics.newFont("font/PressStart2P-Regular.ttf", 40)
        love.graphics.setFont(fontTitle)
        local textWidth = fontTitle:getWidth(textoMensagem)
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()

        drawTextWithBorder(textoMensagem, (windowWidth - textWidth) / 2, windowHeight / 2 - 150, fontTitle, {1, 1, 1}, {0, 0, 0}, 1)

        if #vivos ~= 1 then
            local fontSub = love.graphics.newFont("font/PressStart2P-Regular.ttf", 18)
            love.graphics.setFont(fontSub)
            local textSubWidth = fontSub:getWidth(textoSubMensagem)

            drawTextWithBorder(textoSubMensagem, (windowWidth - textSubWidth) / 2, windowHeight / 2 - 100, fontSub, {1, 1, 1}, {0, 0, 0}, 1)
        end

    end


    love.graphics.setColor(1, 1, 1)
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
        textoMensagem = "Player " .. vivos[1].name .. " venceu!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
        statusVitoria = true

    elseif #vivos == 0 then
        textoMensagem = "Empate!"
        musica:changeMusicGradually("sounds/soundtrack/win.ogg", false)
        mensagemExibida = true
        tempoIniciado = false
        statusVitoria = true
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
        textoMensagem = "Turno do Player " .. players[turno].name
        textoSubMensagem = "Pressione qualquer tecla para iniciar o turno"

        for i, player in ipairs(players) do
            player.mostrarMira = (i == turno)
        end
    end
end


local function controlarJogador(dt)
    local playerAtual = players[turno]
    if tempoIniciado then
        playerAtual:handleInput(dt)
        playerAtual:updateProjectiles(dt)
        if playerAtual.disparou and #playerAtual.projectiles == 1 then
            tempoRestante = 4
        elseif playerAtual.disparou and #playerAtual.projectiles == 0 and tempoRestante > 4 then
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
        functionObjetoInquebravel.handleCollisions(player, objetosInquebravelMapa1)
        functionAgua.handleCollisionsAgua(player, aguasMapa1)
    end

    functionProjetile.handleProjectileCollisions(players, objetosMapa1, objetosInquebravelMapa1, objetosCenarioMapa1)
    
end

function mapa1.update(dt)
    if not pauseMenu.isVisible then
        
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
            atualizarEfeitosDeTexto(dt) 
            atualizarExplosoes(dt)
            atualizarEfeitosDeTexto(dt)
            atualizarFumacas(dt)
            updatePixelClouds(dt)
        end

        if not selecionandoSpawn and not miraInicialAtivada then
            for i, player in ipairs(players) do
                player.mostrarMira = (i == turno)
            end
            miraInicialAtivada = true
        end
    else
        mensagemExibida = false
    end    
end

function mapa1.draw()
    love.graphics.setColor(1, 1, 1)

    if selecionandoSpawn then
        local designWidth = 1920
        local designHeight = 1080

        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()

        local scaleX = windowWidth / designWidth
        local scaleY = windowHeight / designHeight
        local scale = math.min(scaleX, scaleY)

        local offsetX = (windowWidth - designWidth * scale) / 2
        local offsetY = (windowHeight - designHeight * scale) / 2

        love.graphics.push()
        love.graphics.translate(offsetX, offsetY)
        love.graphics.scale(scale)
    else
        love.graphics.push()
        love.graphics.scale(camera.zoom)
        love.graphics.translate(-camera.cameraX, -camera.cameraY)
    end

    backgroundFunction.draw(camera.cameraX, camera.zoom)
    drawObjects()
    drawPlayers()
    desenharEfeitosDeTexto()
    desenharExplosoes()
    desenharEfeitosDeTexto()
    desenharFumacas()
    drawPixelClouds()

    love.graphics.pop()

    drawHud()
    pauseMenu.draw()

    if selecionandoSpawn then
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()

        local playerIndex = 1
        local nomePlayer = "Posicione o Player " .. jogadoresContados + 1

        local font = love.graphics.newFont("font/PressStart2P-Regular.ttf", 28)
        love.graphics.setFont(font)
        local textWidth = font:getWidth(nomePlayer)
        drawTextWithBorder(nomePlayer, (windowWidth - textWidth) / 2, windowHeight / 2 - 200, font, {1, 1, 1}, {0, 0, 0}, 1)

        local mx, my = love.mouse.getPosition()
        local scale = 1.4 
        love.graphics.setColor(1, 1, 1, 0.5) 
        love.graphics.draw(tanqueIcon, mx, my, 0, scale, scale, tanqueIcon:getWidth() / 2, tanqueIcon:getHeight() / 2)
    end
end

function mapa1.mousepressed(x, y, button)
    if selecionandoSpawn and button == 1 then

        if selecionandoSpawn then
            x, y = ajustarCliqueParaTela1920x1080(x, y)
        end

        if jogadoresContados < mapa1.quantidadeJogadores then
            local novoJogadorID = tostring(jogadoresContados + 1)
            
            local tipoTanque = tankTypes[jogadoresContados + 1] or 1 
            
            local novoJogador = Player.new(x, y, novoJogadorID, tipoTanque)
            
            table.insert(players, novoJogador)
            jogadoresContados = jogadoresContados + 1

            if jogadoresContados >= mapa1.quantidadeJogadores then
                selecionandoSpawn = false
            end
        end
    end

    pauseMenu.mousepressed(x, y, button)
end

function ajustarCliqueParaTela1920x1080(x, y)
    local designWidth = 1920
    local designHeight = 1080

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local scaleX = windowWidth / designWidth
    local scaleY = windowHeight / designHeight
    local scale = math.min(scaleX, scaleY)

    local offsetX = (windowWidth - designWidth * scale) / 2
    local offsetY = (windowHeight - designHeight * scale) / 2

    local novoX = (x - offsetX) / scale
    local novoY = (y - offsetY) / scale

    return novoX, novoY
end

function mapa1.keypressed(key)
    if key == "'" then
        mapa1.debugAtivo = not mapa1.debugAtivo
    end

    if not tempoIniciado then
        tempoIniciado = true
        tempoRestante = tempoTurno
    end

    if mensagemExibida and statusVitoria then
        mensagemExibida = false
        pauseMenu.toggle()
        statusVitoria = false
    elseif mensagemExibida then
        mensagemExibida = false
    end

    pauseMenu.keypressed(key)
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
