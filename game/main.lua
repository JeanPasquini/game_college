love.window.setMode(1920, 1080, { fullscreen = false, resizable = false })

local menu = require("menu.main.menu")
local pauseMenu = require("menu.ingame.pauseMenu")

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
                mapa1.load(gameState, selectCharacter.quantidadeJogadores)
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
local gifFrameDuration = 0.04
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

    -- Carregar imagem do botão de pause
    pauseImage = love.graphics.newImage("resources/keyboard/pause.png")
end

function love.load()
    carregarGif()
    carregarTeclas()
    musica:play("sounds/soundtrack/main.ogg")
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
            menu.load(gameState)
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

        -- Desenhar teclas
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        local padding = 20
        local tamanho = 60
        local xBase = screenWidth - tamanho - padding
        local yBase = screenHeight - tamanho - padding

        local ordem = {
            { key = "up", dx = 0, dy = -tamanho },
            { key = "down", dx = 0, dy = 0 },
            { key = "left", dx = -tamanho, dy = 0 },
            { key = "right", dx = tamanho, dy = 0 },
            { key = "space", dx = 0, dy = tamanho },
            { key = "f", dx = 0, dy = tamanho * 2 }
        }

        for _, info in ipairs(ordem) do
            local imgSet = keyImages[info.key]
            if imgSet then
                local img = keyState[info.key] and imgSet.ativo or imgSet.normal
                if img then
                    love.graphics.draw(img, xBase + info.dx, yBase + info.dy)
                end
            end
        end

        -- Desenhar imagem de pause no canto superior direito
        if pauseImage then
            local pauseX = love.graphics.getWidth() - pauseImage:getWidth() - 20
            local pauseY = 20
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
        -- Verificar clique na imagem pause.png
        if pauseImage then
            local px = love.graphics.getWidth() - pauseImage:getWidth() - 20
            local py = 20
            local pw = pauseImage:getWidth()
            local ph = pauseImage:getHeight()

            if x >= px and x <= px + pw and y >= py and y <= py + ph then
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
    if keyState[key] ~= nil then
        keyState[key] = true
    end

    if gameState.estado == "selectCharacter" then
        selectCharacter.keypressed(key)
    elseif gameState.estado == "mapa1" then
        mapa1.keypressed(key)
    end
end

function love.keyreleased(key)
    if keyState[key] ~= nil then
        keyState[key] = false
    end
end
