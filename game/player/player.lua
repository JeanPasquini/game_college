Player = {}
Player.__index = Player
local font

function Player.new(x, y, name)
    local self = setmetatable({}, Player)
    self.x = x or 0
    self.y = y or 0
    self.name = name or ""
    self.life = 5
    self.speed = 5
    self.visible = true
    self.velocidadeY = 0
    self.gravidade = 0.2
    self.pulando = false
    self.alturaMaximaDoPulo = -3.8
    self.projectiles = {} -- Lista para armazenar os projéteis
    self.anguloTiro = 0 -- Ângulo inicial da seta
    self.raioMira = 50 -- Raio da área de tiro
    self.lastShotTime = 0 -- Tempo do último disparo
    self.shootCooldown = 1 -- Tempo de espera entre disparos (em segundos)
    self.forcaTiro = 0
    self.maxForca = 50 -- Força máxima do tiro
    
    self.shootSound = love.audio.newSource("sounds/explosion.wav", "static")
    self.jumpSound = love.audio.newSource("sounds/jump.wav", "static")
    
    self.disparou = false -- Variável para controlar se já disparou
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
    self:handleInput(dt)    -- Lida com os controles de teclado
    self:applyPhysics(dt)   -- Aplica a física do personagem
    self:updateProjectiles(dt)  -- Atualiza os projéteis
end

-- Lida com a entrada do teclado
function Player:handleInput(dt)
        -- Movimentação horizontal
        if love.keyboard.isDown('a') or love.keyboard.isDown('left')then
            self.x = self.x - self.speed
        elseif love.keyboard.isDown('d') or love.keyboard.isDown('right')then
            self.x = self.x + self.speed
        end
    
        -- Pulo
        if love.keyboard.isDown('space') and self.velocidadeY == 0 then
            self.velocidadeY = self.alturaMaximaDoPulo
            self.pulando = true
            love.audio.play(self.jumpSound)
        end
    
        -- Movimentação da mira
        if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
            self.anguloTiro = self.anguloTiro - 0.05
        elseif love.keyboard.isDown('s') or love.keyboard.isDown('down')then
            self.anguloTiro = self.anguloTiro + 0.05
        end
    
        -- Acumula a força enquanto a tecla 'f' é pressionada
        if love.keyboard.isDown('f') or love.keyboard.isDown('p')then
            if self.forcaTiro < self.maxForca then
                self.forcaTiro = self.forcaTiro + 0.5 -- Aumenta a força aos poucos
            end
        elseif self.forcaTiro > 0 then
            self:shoot() -- Dispara quando a tecla 'f' é solta
            self.forcaTiro = 0 -- Reseta a força
        end    
end

-- Aplica a física do personagem (gravidade, movimentação vertical)
function Player:applyPhysics(dt)
    -- Aplica a gravidade ao jogador
    self.velocidadeY = self.velocidadeY + self.gravidade
    self.y = self.y + self.velocidadeY
  
    if self.y >= love.graphics.getHeight() - 32 then
        self.y = love.graphics.getHeight() - 32
        self.velocidadeY = 0
        self.pulando = false 
    end
end

-- Atualiza os projéteis
function Player:updateProjectiles(dt)
    for i, proj in ipairs(self.projectiles) do
        -- Aplica a gravidade no projétil
        proj.velocidadeY = proj.velocidadeY + self.gravidade
        proj.y = proj.y + proj.velocidadeY
        
        -- Movimenta o projétil na direção do ângulo
        proj.x = proj.x + proj.speed * math.cos(proj.angle)
        proj.y = proj.y + proj.speed * math.sin(proj.angle)
    end
end

function Player:shoot()
    local startX = self.x + 16 + self.raioMira * math.cos(self.anguloTiro)
    local startY = self.y + 16 + self.raioMira * math.sin(self.anguloTiro)
    self:newProjectile(startX, startY, self.anguloTiro, self.forcaTiro)
    
    love.audio.play(self.shootSound)
    
    self.disparou = true -- Marca que o jogador disparou
end


function Player:draw()
    love.graphics.setFont(font) 
    -- Desenha o nome do jogador acima do personagem
    love.graphics.setColor(1, 1, 1) -- Cor branca
    love.graphics.print("Player " .. self.name, self.x + 16 - (font:getWidth("Player " .. self.name) / 2), self.y - 30)

    love.graphics.polygon("fill", 
        self.x + 16, self.y - 25 + font:getHeight() + 6, -- Ponta para baixo
        self.x + 16 - 6, self.y - 25 + font:getHeight(), -- Esquerda
        self.x + 16 + 6, self.y - 25 + font:getHeight()  -- Direita
    )

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, 32, 32)
    love.graphics.setColor(1, 1, 1)
    -- Aumenta a espessura da linha de mira
    love.graphics.setLineWidth(4)  

    -- Desenha a seta de mira
    local miraX = self.x + 16 + self.raioMira * math.cos(self.anguloTiro)
    local miraY = self.y + 16 + self.raioMira * math.sin(self.anguloTiro)
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x + 16, self.y + 16, miraX, miraY)
    love.graphics.circle('fill', miraX, miraY, 5)
    -- Desenha os projéteis
    for _, proj in ipairs(self.projectiles) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle('fill', proj.x, proj.y, 5)
    end

    love.graphics.setColor(1, 1, 1)

    -- Desenha a barra de força acompanhando a linha de mira
    local barraForcaX = self.x + 16
    local barraForcaY = self.y + 16
    local barraForcaFimX = barraForcaX + self.forcaTiro * math.cos(self.anguloTiro)
    local barraForcaFimY = barraForcaY + self.forcaTiro * math.sin(self.anguloTiro)

    love.graphics.setColor(0, 1, 0)
    love.graphics.line(barraForcaX, barraForcaY, barraForcaFimX, barraForcaFimY)
    -- Reseta a espessura da linha para o padrão
    love.graphics.setLineWidth(4)  
end

return Player
