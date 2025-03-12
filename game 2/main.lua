love.window.setMode(1920, 1080, { fullscreen = true, resizable = false })

local menu = require("menu.main.menu")
local gameState = { estado = "menu" }  -- Estado inicial: menu

local mapa1 = require("mapa.mapa1.mapa1")
local creditos = require("creditos.creditos")
local opcoes = require("opcoes.opcoes")  -- Novo módulo para a tela de opções

function love.load()
    menu.load(gameState)
    mapa1.load(gameState)
    creditos.load(gameState)
    opcoes.load(gameState)  -- Carrega a tela de opções
end

function love.update(dt)
    if gameState.estado == "mapa1" then
        mapa1.update(dt)
    elseif gameState.estado == "creditos" then
        creditos.update(dt)
    elseif gameState.estado == "opcoes" then
        opcoes.update(dt)  -- Atualiza a tela de opções
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
    elseif gameState.estado == "creditos" then
        creditos.mousepressed(x, y, button)
    elseif gameState.estado == "opcoes" then
        opcoes.mousepressed(x, y, button)  -- Interação na tela de opções
    end
end

function love.mousemoved(x, y, dx, dy)
    if gameState.estado == "menu" then
        menu.mousemoved(x, y)
    elseif gameState.estado == "opcoes" then
        opcoes.mousemoved(x, y)  -- Interação de hover na tela de opções
    end
end