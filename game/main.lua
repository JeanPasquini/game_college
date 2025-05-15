love.window.setMode(1920, 1080, { fullscreen = true, resizable = false })

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
                --if estadoAtual ~= creditos then
                  --  creditos.reset()
                    creditos.load()
                    estadoAtual = creditos
                --end
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
local gifFrameDuration = 0.04 -- 12.5 FPS
local gifPlaying = true
local gifTotalTime = 0
local gifSkipTime = 153 * gifFrameDuration -- duração total da animação em segundos

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


function love.load()
    carregarGif()
    -- Só carrega o menu depois do gif
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
    elseif gameState.estado == "creditos" then
        creditos.draw()
    end

    transition.draw()
end


function love.mousepressed(x, y, button)
    if gameState.estado == "menu" or gameState.estado == "configuracao" then
        menu.mousepressed(x, y, button)
    elseif gameState.estado == "selectCharacter" then
        selectCharacter.mousepressed(x, y, button)
    elseif gameState.estado == "mapa1" then
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
    if gameState.estado == "selectCharacter" then
        selectCharacter.keypressed(key)
    elseif gameState.estado == "mapa1" then
        mapa1.keypressed(key)
    end
end