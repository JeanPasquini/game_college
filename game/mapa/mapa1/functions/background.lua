local background = {}

local layers = {}
local initialOffset = -200

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

        local relativeX = (cameraX * layer.parallax) % imgWidth
        local drawX = -relativeX + initialOffset

        while drawX < windowWidth + imgWidth * 3 do
            love.graphics.draw(img, drawX, layer.y)
            drawX = drawX + imgWidth
        end
    end
end

return background
