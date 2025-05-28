local background = {}

local layers = {}

function background.load()
    layers = {
        {
            image = love.graphics.newImage("resources/backgrounds/paralax/sky.png"),
            parallax = 0,
            y = 0
        },
        {
            image = love.graphics.newImage("resources/backgrounds/paralax/clouds.png"),
            parallax = 0.4,
            y = 300
        },
        {
            image = love.graphics.newImage("resources/backgrounds/paralax/sea.png"),
            parallax = 0.8,
            y = 820
        },
        {
            image = love.graphics.newImage("resources/backgrounds/paralax/far-grounds.png"),
            parallax = 0.9,
            y = 800
        }
    }
end

function background.draw(cameraX)
    local windowWidth = love.graphics.getWidth()

    for _, layer in ipairs(layers) do
        local img = layer.image
        local imgWidth = img:getWidth()

        -- Ajuste parallax com base na posição da câmera
        local relativeX = (cameraX * layer.parallax) % imgWidth
        local drawX = -relativeX

        -- Desenha a imagem repetidamente para preencher a tela
        while drawX < windowWidth do
            love.graphics.draw(img, drawX, layer.y)
            drawX = drawX + imgWidth
        end
    end
end

return background
