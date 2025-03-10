love.window.setMode(1920, 1080, { fullscreen = false, resizable = false })

local menu = require("menu.main.menu")
local gameState = { estado = "menu" }

local mapa1 = require("mapa.mapa1.mapa1")

function love.load()
    menu.load(gameState)
    mapa1.load(gameState)
end

function love.update(dt)
    if gameState.estado == "mapa1" then
        mapa1.update(dt)
    end
end

function love.draw()
    if gameState.estado == "menu" then
        menu.draw()
    elseif gameState.estado == "mapa1" then
        mapa1.draw()
    end
end

function love.mousepressed(x, y, button)
    if gameState.estado == "menu" then
        menu.mousepressed(x, y, button)
    end
end