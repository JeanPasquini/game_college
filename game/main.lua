-- Ctrl + B para executar

love.window.setMode(1920, 1080, { fullscreen = false, resizable = false })  -- Corrigido "façse" para "false"

local menu = require("menu.main.menu")
local creditos = require("menu.main.creditos")
local selectCharacter = require("menu.main.selectCharacter")
local mapa1 = require("mapa.mapa1.mapa1")  -- Certifique-se de que o mapa1 foi carregado corretamente

local gameState = { estado = "menu", estadoCarregado = nil }  -- Adicionado o estadoCarregado para controle de carregamento de estado
local quantidadeJogadores = 2

-- Carregar música e efeitos sonoros
_G.musica = require("sounds/soundtrack")
_G.efeitoSonoro = require("sounds/soundeffect")

function love.load()
    musica:play("sounds/soundtrack/main.ogg")  -- Ajuste para utilizar a variável correta para música
    menu.load(gameState)  
end

function love.update(dt)
    musica:update(dt)  -- Atualizar música

    -- Verificar se o estado foi carregado
    if gameState.estado ~= gameState.estadoCarregado then
        if gameState.estado == "selectCharacter" then
            selectCharacter.load(gameState, quantidadeJogadores)
        elseif gameState.estado == "menu" or gameState.estado == "configuracao" then
            menu.load(gameState)
        elseif gameState.estado == "mapa1" then
            mapa1.load(gameState, selectCharacter.quantidadeJogadores)
        end
        gameState.estadoCarregado = gameState.estado
    end

    if gameState.estado == "selectCharacter" then
        selectCharacter.update(dt)
    elseif gameState.estado == "mapa1" then
        mapa1.update(dt)
    elseif gameState.estado == "menu" or gameState.estado == "configuracao" then
        creditos.update(dt)
    end
end

function love.draw()
    if gameState.estado == "menu" or gameState.estado == "configuracao" then
        menu.draw()
    elseif gameState.estado == "selectCharacter" then
        selectCharacter.draw()
    elseif gameState.estado == "mapa1" then
        mapa1.draw()
    elseif gameState.estado == "creditos" then
        creditos.draw()
    end
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
end

function love.keypressed(key)
    -- Lidar com pressionamento de teclas
    if gameState.estado == "selectCharacter" then
        selectCharacter.keypressed(key)
    elseif gameState.estado == "mapa1" then
        mapa1.keypressed(key)
    end
end
