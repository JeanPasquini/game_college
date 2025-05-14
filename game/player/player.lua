Player = {}
Player.__index = Player
local font

function Player.new(x, y, name)
    local self = setmetatable({}, Player)
    self.x = x or 0
    self.y = y or 0
    self.name = name or ""
    self.life = 100
    self.maxLife = 100
    self.speed = 0.5
    self.visible = true
    self.velocidadeY = 0
    self.gravidade = 0.1
    self.pulando = false
    self.disparando = false
    self.alturaMaximaDoPulo = -2.8
    self.projectiles = {}
    self.anguloTiro = 0
    self.raioMira = 30
    self.lastShotTime = 0
    self.shootCooldown = 1
    self.forcaTiro = 0
    self.maxForca = 30
    self.knockbackX = 0
    self.knockbackY = 0
    self.damage = 100
    self.mostrarMira = false

    self.shootSound = love.audio.newSource("sounds/soundeffect/explosion.wav", "static")
    self.jumpSound = love.audio.newSource("sounds/soundeffect/jump.wav", "static")

    self.disparou = false

    font = love.graphics.newFont("font/PressStart2P-Regular.ttf", 10)
    love.graphics.setFont(font)

    return self
end



function Player:newProjectile(startX, startY, angle, speed)
    local projectile = {
        x = startX,
        y = startY,
        speed = speed,
        angle = angle,
        velocidadeY = 0,
    }
    table.insert(self.projectiles, projectile)
end

function Player:update(dt)
    self:handleInput(dt)
    self:applyPhysics(dt)
    self:updateProjectiles(dt)
    atualizarFumacas(dt)
end


function Player:handleInput(dt)
    if not self.disparando then
        if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
            self.x = self.x - self.speed
            self.viradoParaDireita = false 
        elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
            self.x = self.x + self.speed
            self.viradoParaDireita = true 
        end
        if love.keyboard.isDown('space') and self.velocidadeY == 0 then
            self.velocidadeY = self.alturaMaximaDoPulo
            efeitoSonoro:play("sounds/soundeffect/jump.wav")
        end
    end
end

function Player:lifePlayer(dt)
    if self.life == 0 then
        self.visible = false
    end
end

function Player:applyPhysics(dt)
    if self.velocidadeY == 0 then
        self.pulando = false
    else
        self.pulando = true
    end

    self.velocidadeY = self.velocidadeY + self.gravidade
    self.y = self.y + self.velocidadeY
  
    if self.y >= love.graphics.getHeight() - 32 then
        self.y = love.graphics.getHeight() - 32
        self.velocidadeY = 0
        
    end

    self.x = self.x + self.knockbackX * dt
    self.y = self.y + self.knockbackY * dt

    self.knockbackX = self.knockbackX * 0.9
    self.knockbackY = self.knockbackY * 0.9

end

function Player:updateProjectiles(dt)
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.anguloTiro = self.anguloTiro - 0.05
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down')then
        self.anguloTiro = self.anguloTiro + 0.05
    end

    if not self.pulando and not self.disparou then
        if love.keyboard.isDown('f') or love.keyboard.isDown('p')then
            self.disparando = true
            if self.forcaTiro < self.maxForca then
                self.forcaTiro = self.forcaTiro + 0.5
            end
        elseif self.forcaTiro > 0 then
            self.disparando = false
            self:shoot()
            self.forcaTiro = 0
        end    
    end

    for i, proj in ipairs(self.projectiles) do
        proj.velocidadeY = proj.velocidadeY + (self.gravidade * 2)
        proj.y = proj.y + proj.velocidadeY

        proj.x = proj.x + proj.speed * math.cos(proj.angle)
        proj.y = proj.y + proj.speed * math.sin(proj.angle)

        if proj.x < 0 or proj.x > 1920 or proj.y > 1080 then
            table.remove(self.projectiles, i)
        end
    end


end

function Player:shoot()

    local canhaoComprimento = 45 
    local canhaoX = self.x + 32 + canhaoComprimento * math.cos(self.anguloTiro)
    local canhaoY = self.y + 10 + canhaoComprimento * math.sin(self.anguloTiro)
    
    self:newProjectile(canhaoX, canhaoY, self.anguloTiro, self.forcaTiro)
    efeitoSonoro:play("sounds/soundeffect/shoot.wav")
    self.disparou = true

    criarFumaca(canhaoX, canhaoY, self.anguloTiro)
end



function Player:draw()
    local playerImage = love.graphics.newImage("resources/sprites/tank/tank.png")
    local canhaoImage = love.graphics.newImage("resources/sprites/tank/canhao.png")

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Player " .. self.name, self.x + 32 - (font:getWidth("Player " .. self.name) / 2), self.y - 30)

    love.graphics.polygon("fill", 
        self.x + 32, self.y - 25 + font:getHeight() + 6, 
        self.x + 32 - 6, self.y - 25 + font:getHeight(), 
        self.x + 32 + 6, self.y - 25 + font:getHeight() 
    )

    love.graphics.push()
    if self.viradoParaDireita then
        love.graphics.scale(-1, 1)
        love.graphics.draw(playerImage, -self.x - playerImage:getWidth(), self.y)
    else
        love.graphics.draw(playerImage, self.x, self.y)
    end
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(self.x + 32, self.y + 8) 
    love.graphics.rotate(self.anguloTiro)
    

    love.graphics.scale(-1, 1) 

    love.graphics.draw(canhaoImage, -canhaoImage:getWidth(), -canhaoImage:getHeight()/2) 
    love.graphics.pop()  

    love.graphics.setColor(1, 1, 1)

    local miraX = self.x + 32 + self.raioMira * math.cos(self.anguloTiro)
    local miraY = self.y + 8 + self.raioMira * math.sin(self.anguloTiro)

    for _, proj in ipairs(self.projectiles) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle('fill', proj.x, proj.y, 10, 10)
    end

    love.graphics.setColor(1, 1, 1)

    if self.mostrarMira then
        local miraDistanteX = self.x + 32 + (self.raioMira + 60) * math.cos(self.anguloTiro)
        local miraDistanteY = self.y + 8 + (self.raioMira + 60) * math.sin(self.anguloTiro)

        love.graphics.setColor(0, 1, 0)
        local size = 22
        love.graphics.setLineWidth(2)

        love.graphics.line(miraDistanteX, miraDistanteY - size, miraDistanteX, miraDistanteY + size)
        love.graphics.line(miraDistanteX - size, miraDistanteY, miraDistanteX + size, miraDistanteY)

        local squareSize = 28
        love.graphics.rectangle("line", miraDistanteX - squareSize / 2, miraDistanteY - squareSize / 2, squareSize, squareSize)

        local origemX = miraX
        local origemY = miraY
        local destinoX = miraDistanteX
        local destinoY = miraDistanteY

        local dx = destinoX - origemX
        local dy = destinoY - origemY
        local distanciaTotal = math.sqrt(dx * dx + dy * dy)

        local maxBolinhas = 10
        local espacamento = distanciaTotal / maxBolinhas

        local numBolinhas = math.floor((self.forcaTiro / self.maxForca) * maxBolinhas)

        for i = 1, numBolinhas do
            local progress = i / maxBolinhas
            local bolinhaX = origemX + i * espacamento * math.cos(self.anguloTiro)
            local bolinhaY = origemY + i * espacamento * math.sin(self.anguloTiro)
            
            local bolinhaSize = 8 + progress * 10
            love.graphics.setColor(progress, 1 - progress, 0)
        
            love.graphics.rectangle("fill", bolinhaX - bolinhaSize / 2, bolinhaY - bolinhaSize / 2, bolinhaSize, bolinhaSize)
        end
    end

end

local smokeAnimations = {}

local smokeSprites = {}
for i = 1, 10 do
    smokeSprites[i] = love.graphics.newImage(string.format("resources/sprites/smoke/smoke%d.png", i))
end

local smokeAnimations = {}

local smokeSprites = {}
for i = 1, 10 do
    smokeSprites[i] = love.graphics.newImage(string.format("resources/sprites/smoke/smoke%d.png", i))
end

function criarFumaca(canhaoX, canhaoY, angle)
    local novaFumaca = {
        x = canhaoX,
        y = canhaoY,
        angle = angle,
        frame = 1,
        frameDuration = 0.05,
        timeElapsed = 0
    }
    table.insert(smokeAnimations, novaFumaca)
end

function atualizarFumacas(dt)
    for i = #smokeAnimations, 1, -1 do
        local fumaca = smokeAnimations[i]
        fumaca.timeElapsed = fumaca.timeElapsed + dt
        if fumaca.timeElapsed >= fumaca.frameDuration then
            fumaca.timeElapsed = 0
            fumaca.frame = fumaca.frame + 1
            if fumaca.frame > #smokeSprites then
                table.remove(smokeAnimations, i)
            end
        end
    end
end

function desenharFumacas()
    for _, fumaca in ipairs(smokeAnimations) do
        local sprite = smokeSprites[fumaca.frame]
        local largura = sprite:getWidth()
        local altura = sprite:getHeight()
        
        local escala = 2

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            sprite,
            fumaca.x, 
            fumaca.y, 
            fumaca.angle, 
            escala, 
            escala, 
            largura / 2, 
            altura / 2
        )
        love.graphics.setColor(1, 1, 1)
    end
end





function Player:getPosition()
    return self.x, self.y
end


return Player
