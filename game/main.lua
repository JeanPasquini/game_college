love.window.setMode(1920, 1080, { fullscreen = false, resizable = false })

local menu = require("menu.main.menu")
local pauseMenu = require("menu.ingame.pauseMenu")
local musicaIntro
local pressStartFont

local creditos = require("menu/main/creditos")
local selectCharacter = require("menu.main.selectCharacter")
local mapa1 = require("mapa.mapa1.mapa1")
local transition = require("menu.main.transition")
local estadoParaTrocar = nil

local gameState = { estado = "menu", estadoCarregado = nil }

function trocarEstado(novoEstado)
    if gameState.estado ~= novoEstado and not transition.isActive() then
        estadoParaTrocar = novoEstado
        transition.start(function()
            gameState.estado = estadoParaTrocar
            if gameState.estado == "selectCharacter" then
                selectCharacter.load(gameState, quantidadeJogadores)
            elseif gameState.estado == "menu" or gameState.estado == "configuracao" then
                menu.load(gameState)
            elseif gameState.estado == "mapa1" then
                mapa1.load(gameState, selectCharacter.quantidadeJogadores, selectCharacter.tiposJogadores)
            elseif gameState.estado == "creditos" then
                creditos.load()
                estadoAtual = creditos
            end
            gameState.estadoCarregado = gameState.estado
        end)
    end
end

local quantidadeJogadores = 2

_G.musica = require("sounds/soundtrack")
_G.efeitoSonoro = require("sounds/soundeffect")

local gifFrames = {}
local gifIndex = 1
local gifTimer = 0
local gifFrameDuration = 0.097
local gifPlaying = true
local gifTotalTime = 0
local gifSkipTime = 153 * gifFrameDuration

-- Teclas (sprites)
local keyImages = {}
local keyState = {}
local pauseImage

function carregarGif()
    local i = 0
    while true do
        local filename = string.format("resources/gif/0515-%d.png", i)
        if love.filesystem.getInfo(filename) then
            table.insert(gifFrames, love.graphics.newImage(filename))
            i = i + 1
        else
            break
        end
    end
end

function carregarTeclas()
    local teclas = {
        { nome = "cima", tecla = "up" },
        { nome = "baixo", tecla = "down" },
        { nome = "esquerda", tecla = "left" },
        { nome = "direita", tecla = "right" },
        { nome = "F", tecla = "f" },
        { nome = "space", tecla = "space" }
    }

    for _, t in ipairs(teclas) do
        keyImages[t.tecla] = {
            normal = love.graphics.newImage("resources/keyboard/" .. t.nome .. ".png"),
            ativo = love.graphics.newImage("resources/keyboard/" .. t.nome .. "A.png")
        }
        keyState[t.tecla] = false
    end

    pauseImage = love.graphics.newImage("resources/keyboard/pause.png")
end

function love.load()
    carregarGif()
    carregarTeclas()
    pressStartFont = love.graphics.newFont("font/PressStart2P-Regular.ttf", 12)
    musicaIntro = love.audio.newSource("sounds/soundtrack/intro.MP3", "stream")
    musicaIntro:setLooping(false)
    musicaIntro:play()

end

function love.update(dt)
    if gifPlaying then
        gifTimer = gifTimer + dt
        gifTotalTime = gifTotalTime + dt
        if gifTimer >= gifFrameDuration then
            gifTimer = gifTimer - gifFrameDuration
            gifIndex = gifIndex + 1
            if gifIndex > #gifFrames then gifIndex = 1 end
        end
        if gifTotalTime >= gifSkipTime then
            gifPlaying = false
            if musicaIntro then
                musicaIntro:stop()
            end
            menu.load(gameState)
            musica:play("sounds/soundtrack/main.ogg")
        end
        return
    end

    musica:update(dt)
    transition.update(dt)

    if gameState.estado == "selectCharacter" then
        selectCharacter.update(dt)
    elseif gameState.estado == "mapa1" then
        mapa1.update(dt)
    elseif gameState.estado == "menu" or gameState.estado == "configuracao" then
        creditos.update(dt)
    elseif estadoAtual and estadoAtual.update then
        estadoAtual.update(dt)
    end
end

function love.draw()
    if gifPlaying then
        if gifFrames[gifIndex] then
            local img = gifFrames[gifIndex]
            love.graphics.draw(img, 0, 0, 0,
                love.graphics.getWidth() / img:getWidth(),
                love.graphics.getHeight() / img:getHeight()
            )
        end
        return
    end

    if gameState.estado == "menu" or gameState.estado == "configuracao" then
        menu.draw()
    elseif gameState.estado == "selectCharacter" then
        selectCharacter.draw()
    elseif gameState.estado == "mapa1" then
        mapa1.draw()

-- Desenhar barra inferior com fundo, sombra de texto e alinhamento centralizado
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local imgSize = 48
local spacing = 20 -- entre seções
local innerSpacing = 5 -- entre teclas na mesma seção
local baseY = screenHeight - imgSize + 5
local font = pressStartFont
love.graphics.setFont(font)

-- Define dados do layout
local layout = {
    {
        label = "Angulação:",
        keys = {
            { key = "up", dx = 0, dy = 0 },
            { key = "down", dx = 0, dy = imgSize - 30 }
        }
    },
    {
        label = "Movimentação:",
        keys = {
            { key = "left", dx = 0, dy = 0 },
            { key = "right", dx = imgSize - 30, dy = 0 }
        }
    },
    {
        label = "Pular:",
        keys = {
            { key = "space", dx = 0, dy = 0 }
        }
    },
    {
        label = "Atirar:",
        keys = {
            { key = "f", dx = 0, dy = 0 }
        }
    }
}

-- Calcula largura total
local totalWidth = 0
local sectionWidths = {}
for _, section in ipairs(layout) do
    local textWidth = font:getWidth(section.label)
    local sectionWidth = textWidth
    for _, key in ipairs(section.keys) do
        sectionWidth = math.max(sectionWidth, key.dx + imgSize)
    end
    sectionWidth = sectionWidth + imgSize + 10 -- espaço entre texto e teclas
    table.insert(sectionWidths, sectionWidth)
    totalWidth = totalWidth + sectionWidth + spacing
end
totalWidth = totalWidth - spacing -- remover o último extra

local startX = (screenWidth - totalWidth) / 2
local boxHeight = imgSize + 30
local boxY = baseY - 10

-- Caixa translúcida de fundo
--love.graphics.setColor(0, 0, 0, 0.4)
--love.graphics.rectangle("fill", startX - 20, boxY - 10, totalWidth + 40, boxHeight + 20, 12, 12)

-- Desenha cada seção
for i, section in ipairs(layout) do
    local x = startX
    local label = section.label
    local textWidth = font:getWidth(label)
    local textHeight = font:getHeight()

    -- Centralizar verticalmente com a imagem mais alta da seção
    local imgBlockHeight = 0
    for _, k in ipairs(section.keys) do
        imgBlockHeight = math.max(imgBlockHeight, k.dy + imgSize)
    end
    local totalHeight = math.max(textHeight, imgBlockHeight)
    local textY = baseY + (totalHeight - textHeight) / 7 --importante

    -- Texto com sombra
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.print(label, x + 1, textY + 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(label, x, textY)

    -- Teclas ao lado do texto
    local keyX = x + textWidth + 10
    for _, keyInfo in ipairs(section.keys) do
        local imgSet = keyImages[keyInfo.key]
        if imgSet then
            local img = keyState[keyInfo.key] and imgSet.ativo or imgSet.normal
            love.graphics.draw(img, keyX + keyInfo.dx, baseY + keyInfo.dy)
        end
    end

    startX = startX + sectionWidths[i] + spacing
end

        -- Desenhar imagem de pause no canto superior direito
        -- Desenhar imagem de pause no canto inferior esquerdo, abaixo do HUD
    if pauseImage then
        local margin = 145
        local baseY = love.graphics.getHeight() - 210 -- mesmo Y do relógio
       -- local hudHeight = 100 + 40 + 10 -- clock + espaço + texto Round
        local pauseX = margin + 5
        local pauseY = baseY + 50 + 40 + 10 -- abaixo do "Round"
        love.graphics.draw(pauseImage, pauseX, pauseY)
    end

        
    elseif gameState.estado == "creditos" then
        creditos.draw()
    end

    transition.draw()
end

function love.mousepressed(x, y, button)
    if gifPlaying then return end

    if gameState.estado == "menu" or gameState.estado == "configuracao" then
        menu.mousepressed(x, y, button)
    elseif gameState.estado == "selectCharacter" then
        selectCharacter.mousepressed(x, y, button)
    elseif gameState.estado == "mapa1" then
    -- Verificar clique no botão de pause
        if pauseImage then
            local margin = 145
            local baseY = love.graphics.getHeight() - 210
            ---local hudHeight = 50 + 40 + 10
            local pauseX = margin + 5
            local pauseY = baseY + 50 + 40 + 10
            local pw = pauseImage:getWidth()
            local ph = pauseImage:getHeight()

            if x >= pauseX and x <= pauseX + pw and y >= pauseY and y <= pauseY + ph then
             pauseMenu.toggle()
                return
            end
        end

        mapa1.mousepressed(x, y, button)
    elseif gameState.estado == "creditos" then
        creditos.mousepressed(x, y, button)
    end
end


function love.mousemoved(x, y, dx, dy)
    if gameState.estado == "menu" or gameState.estado == "configuracao" then
        if menu.mousemoved then
            menu.mousemoved(x, y, dx, dy)
        end
    elseif gameState.estado == "selectCharacter" then
        if selectCharacter.mousemoved then
            selectCharacter.mousemoved(x, y, dx, dy)
        end
    elseif gameState.estado == "mapa1" then
        if mapa1.mousemoved then
            mapa1.mousemoved(x, y, dx, dy)
        end
    end
    if estadoAtual and estadoAtual.mousemoved then
        estadoAtual.mousemoved(x, y)
    end
end

function love.keypressed(key)
    -- Mapeamento WASD
    local map = {
        w = "up",
        s = "down",
        a = "left",
        d = "right"
    }

    local mappedKey = map[key] or key
    if keyState[mappedKey] ~= nil then
        keyState[mappedKey] = true
    end

    if gameState.estado == "selectCharacter" then
        selectCharacter.keypressed(key)
    elseif gameState.estado == "mapa1" then
        mapa1.keypressed(key)
    end
end


function love.keyreleased(key)
    local map = {
        w = "up",
        s = "down",
        a = "left",
        d = "right"
    }

    local mappedKey = map[key] or key
    if keyState[mappedKey] ~= nil then
        keyState[mappedKey] = false
    end
end