local transition = {
    active = false,
    closing = true,
    position = love.graphics.getHeight(),
    speed = 2000,
    onFinish = nil,
    waiting = false,
    images = {},
    extraDelay = nil,
    extraDelayMultiplier = 14 
}




function transition.load()
    transition.images.upGate = love.graphics.newImage("resources/sprites/gate/upGate.png")
    transition.images.downGate = love.graphics.newImage("resources/sprites/gate/downGate.png")
end

function transition.start(callback, delay, delayMultiplier)
    transition.active = true
    transition.closing = true
    transition.position = love.graphics.getHeight()
    transition.onFinish = callback
    transition.waiting = false
    transition.extraDelay = delay or nil
    transition.extraDelayMultiplier = delayMultiplier or 14
end


function transition.playAnimation()
    transition.active = true
    transition.closing = true
    transition.position = love.graphics.getHeight() 
    transition.onFinish = nil 
    transition.waiting = false
end



function transition.update(dt)
    if not transition.active then return end

    local dir = transition.closing and -1 or 1

    local effectiveSpeed = transition.speed
    if not transition.closing and transition.extraDelay then
        effectiveSpeed = transition.speed  / transition.extraDelayMultiplier
    end

    transition.position = transition.position + dir * effectiveSpeed * dt

    if transition.closing then
        if transition.position <= 0 then
            transition.position = 0
            transition.closing = false
            if not transition.waiting and transition.onFinish then
                transition.onFinish()
                efeitoSonoro:play("sounds/soundeffect/gate.wav")
                transition.waiting = true
            end
        end
    else
        if transition.position >= love.graphics.getHeight() then
            transition.position = love.graphics.getHeight()
            transition.active = false
            transition.extraDelay = nil 
        end
    end
end





function transition.draw()
    if not transition.active and transition.position >= love.graphics.getHeight() then
        return
    end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local upGateImg = transition.images.upGate
    local downGateImg = transition.images.downGate

    if upGateImg and downGateImg then
        local scaleX = screenWidth / upGateImg:getWidth()
        local scaleY = screenHeight / upGateImg:getHeight()

        love.graphics.draw(downGateImg, 0, transition.position, 0, scaleX, scaleY)
        love.graphics.draw(upGateImg, 0, -transition.position, 0, scaleX, scaleY)
    end
end



function transition.isActive()
    return transition.active
end

return transition
