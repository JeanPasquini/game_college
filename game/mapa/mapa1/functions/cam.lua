-- Camera.lua
local Camera = {}
Camera.__index = Camera

function Camera.new(cameraLimitX, cameraLimitY, zoom)
    local self = setmetatable({}, Camera)
    self.cameraX = 0
    self.cameraY = 0
    self.cameraLimitX = cameraLimitX
    self.cameraLimitY = cameraLimitY
    self.zoom = zoom or 1.2
    self.smoothSpeed = 5 -- quanto maior, mais rápido a câmera segue o alvo
    return self
end

-- Função de interpolação linear
local function lerp(a, b, t)
    return a + (b - a) * t
end

function Camera:update(dt, target)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local windowWidthZoomed, windowHeightZoomed = windowWidth / self.zoom, windowHeight / self.zoom
    local targetX, targetY = target.x, target.y

    -- Calcula a posição ideal da câmera
    local desiredX = targetX - windowWidthZoomed / 2
    local desiredY = targetY - windowHeightZoomed / 2

    -- Aplica limites horizontais
    desiredX = math.max(0, math.min(desiredX, self.cameraLimitX - windowWidthZoomed))
    desiredY = math.max(0, math.min(desiredY, self.cameraLimitY - windowHeightZoomed))

    -- Interpola suavemente a posição da câmera
    self.cameraX = lerp(self.cameraX, desiredX, dt * self.smoothSpeed)
    self.cameraY = lerp(self.cameraY, desiredY, dt * self.smoothSpeed)
end

function Camera:setPosition(x, y)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local windowWidthZoomed = windowWidth / self.zoom
    local windowHeightZoomed = windowHeight / self.zoom

    local cameraX = x - windowWidthZoomed / 2
    local cameraY = y - windowHeightZoomed / 2

    self.cameraX = math.max(0, math.min(cameraX, self.cameraLimitX - windowWidthZoomed))
    self.cameraY = math.max(0, math.min(cameraY, self.cameraLimitY - windowHeightZoomed))
end

return Camera
