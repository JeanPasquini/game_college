local Camera = {}
Camera.__index = Camera

function Camera.new(limitX, limitY, zoom)
    return setmetatable({
        cameraX = 0,
        cameraY = 0,
        cameraLimitX = limitX,
        cameraLimitY = limitY,
        zoom = zoom or 1.2,
        smoothSpeed = 5
    }, Camera)
end

local function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function getZoomedWindowSize(zoom)
    local w, h = love.graphics.getDimensions()
    return w / zoom, h / zoom
end

function Camera:update(dt, target)
    local zoomedW, zoomedH = getZoomedWindowSize(self.zoom)
    local desiredX = clamp(target.x - zoomedW / 2, 0, self.cameraLimitX - zoomedW)
    local desiredY = clamp(target.y - zoomedH / 2, 0, self.cameraLimitY - zoomedH)

    self.cameraX = lerp(self.cameraX, desiredX, dt * self.smoothSpeed)
    self.cameraY = lerp(self.cameraY, desiredY, dt * self.smoothSpeed)
end

function Camera:setPosition(x, y)
    local zoomedW, zoomedH = getZoomedWindowSize(self.zoom)
    self.cameraX = clamp(x - zoomedW / 2, 0, self.cameraLimitX - zoomedW)
    self.cameraY = clamp(y - zoomedH / 2, 0, self.cameraLimitY - zoomedH)
end

function Camera:ajustarZoomParaResolucao()
    local larguraAtual = love.graphics.getWidth()
    local alturaAtual = love.graphics.getHeight()

    local baseLargura = 1920
    local baseAltura = 1080

    local escalaX = larguraAtual / baseLargura
    local escalaY = alturaAtual / baseAltura

    local novoZoom = math.min(escalaX, escalaY, 1.0)

    self.zoom = novoZoom * self.zoom 

    print(string.format("Zoom ajustado: %.2f", self.zoom))
end


return Camera
