-- Ctrl + B para executar

love.window.setMode(1920, 1080, { fullscreen = true, resizable = false })

local menu = require("menu.main.menu")
local creditos = require("menu.main.creditos")
local opcoes = require("menu.main.opcoes")  -- Novo módulo para a tela de opções

local gameState = { estado = "menu" }  -- Estado inicial: menu
local mapa1 = require("mapa.mapa1.mapa1")
_G.musica = require("sounds/soundtrack")
_G.efeitoSonoro = require("sounds/soundeffect")

function love.load()
    musica:play("sounds/soundtrack/main.ogg") 
    menu.load(gameState)  
end

function love.update(dt)
    musica:update(dt)

    -- Se o estado mudou, carregue o novo estado apenas uma vez
    if gameState.estado ~= gameState.estadoCarregado then
        if gameState.estado == "mapa1" then
            mapa1.load(gameState)
        elseif gameState.estado == "creditos" then
            creditos.load(gameState)
        elseif gameState.estado == "opcoes" then
            opcoes.load(gameState)
        end

        gameState.estadoCarregado = gameState.estado  -- Atualiza o controle
    end

    -- Atualiza o estado atual
    if gameState.estado == "mapa1" then
        mapa1.update(dt)
    elseif gameState.estado == "creditos" then
        creditos.update(dt)
    elseif gameState.estado == "opcoes" then
        opcoes.update(dt)
    end
end


function love.draw()
    if gameState.estado == "menu" then
        menu.draw()
    elseif gameState.estado == "mapa1" then
        mapa1.draw()
    elseif gameState.estado == "creditos" then
        creditos.draw()
    elseif gameState.estado == "opcoes" then
        opcoes.draw()  -- Desenha a tela de opções
    end
end


function love.mousepressed(x, y, button)
    if gameState.estado == "menu" then
        menu.mousepressed(x, y, button)
    elseif gameState.estado == "mapa1" then

        mapa1.mousepressed(x, y, button)  -- Adiciona o evento do mapa1
    elseif gameState.estado == "creditos" then
        
        creditos.mousepressed(x, y, button)
    elseif gameState.estado == "opcoes" then
        
        opcoes.mousepressed(x, y, button)
    end
end

function love.mousemoved(x, y, dx, dy)
    if gameState.estado == "menu" then
        menu.mousemoved(x, y)
    elseif gameState.estado == "opcoes" then
        opcoes.mousemoved(x, y)  -- Interação de hover na tela de opções
    end
end

function love.keypressed(key)
    if gameState.estado == "mapa1" then
        mapa1.keypressed(key)
    end
end