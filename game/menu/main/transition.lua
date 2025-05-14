local transition = {
    active = false,
    closing = true,
    height = 0,
    speed = 3000,
    onFinish = nil,
    waiting = false,
}

function transition.start(callback)
    transition.active = true
    transition.closing = true
    transition.height = 0
    transition.onFinish = callback
    transition.waiting = false
end

function transition.update(dt)
    if not transition.active then return end

    local dir = transition.closing and 1 or -1
    transition.height = transition.height + dir * transition.speed * dt

    if transition.closing and transition.height >= love.graphics.getHeight() / 2 then
        transition.height = love.graphics.getHeight() / 2
        transition.closing = false
        if not transition.waiting and transition.onFinish then
            transition.onFinish()
            transition.waiting = true -- evita chamar mais de uma vez
        end
    elseif not transition.closing and transition.height <= 0 then
        transition.height = 0
        transition.active = false
    end
end

function transition.draw()
    if not transition.active and transition.height <= 0 then return end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), transition.height)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - transition.height, love.graphics.getWidth(), transition.height)
    love.graphics.setColor(1, 1, 1)
end

function transition.isActive()
    return transition.active
end

return transition
