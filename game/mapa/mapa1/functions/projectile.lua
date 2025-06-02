local functionProjetile = {}
local efeitoTexto = {}
local explosoes = {}

local explosionSprites = {}
for i = 1, 8 do
    explosionSprites[i] = love.graphics.newImage("resources/sprites/explosion/explosion" .. i .. ".png")
end

function functionProjetile.checkCollisionProjectile(proj, objeto)
    return proj.x < objeto.x + objeto.width and
           proj.x + 5 > objeto.x and
           proj.y < objeto.y + objeto.height and
           proj.y + 5 > objeto.y
end

function functionProjetile.checkCollisionWithPlayer(proj, player)
    local projX = proj.x
    local projY = proj.y

    local left = player.x
    local right = player.x + player.width
    local top = player.y
    local bottom = player.y + player.height

    return projX >= left and projX <= right and projY >= top and projY <= bottom
end

function criarExplosao(x, y)
    local explosao = {
        x = x,
        y = y,
        tamanhoMaximo = 50,
        tempoVida = 0.8,
        tempoAtual = 0,
        quadrados = {}
    }

    local tamanhos = {10, 13, 15, 20}
    local cores = {
        {1, 0.5, 0},
        {1, 0.3, 0},
        {1, 0.8, 0},
        {0.8, 0.2, 0}
    }

    for i = 1, 20 do 
        local angulo = math.random() * math.pi * 2
        local distancia = math.random() * explosao.tamanhoMaximo
        local tamanho = tamanhos[math.random(1, #tamanhos)]
        local cor = cores[math.random(1, #cores)]

        table.insert(explosao.quadrados, {
            x = x + math.cos(angulo) * distancia,
            y = y + math.sin(angulo) * distancia,
            tamanho = tamanho,
            cor = cor,
            opacidade = 1
        })
    end

    table.insert(explosoes, explosao)
end

function atualizarExplosoes(dt)
    for i = #explosoes, 1, -1 do
        local explosao = explosoes[i]
        explosao.tempoAtual = explosao.tempoAtual + dt
        local progresso = explosao.tempoAtual / explosao.tempoVida

        for _, quadrado in ipairs(explosao.quadrados) do
            quadrado.opacidade = 1 - progresso
        end

        if explosao.tempoAtual >= explosao.tempoVida then
            table.remove(explosoes, i)
        end
    end
end

function desenharExplosoes()
    for _, explosao in ipairs(explosoes) do
        for _, quadrado in ipairs(explosao.quadrados) do
            love.graphics.setColor(quadrado.cor[1], quadrado.cor[2], quadrado.cor[3], quadrado.opacidade)
            love.graphics.rectangle("fill", quadrado.x, quadrado.y, quadrado.tamanho, quadrado.tamanho)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function calcularDanoPorProximidade(proj, target)
    local dx = target.x - proj.x
    local dy = target.y - proj.y
    local dist2 = dx * dx + dy * dy
    local distanciaMaxima2 = 100 * 100
    if dist2 > distanciaMaxima2 then return 0 end
    local danoMaximo = proj.damage
    local danoFinal = danoMaximo * (1 - dist2 / distanciaMaxima2)
    return math.floor(danoFinal)
end

function criarEfeitoTexto(x, y, vidaPerdida)
    if #efeitoTexto >= 10 then table.remove(efeitoTexto, 1) end
    local efeito = {
        x = x,
        y = y,
        texto = "-" .. math.floor(vidaPerdida),
        tempoVida = 1,
        velocidade = 50
    }
    table.insert(efeitoTexto, efeito)
end

function atualizarEfeitosDeTexto(dt)
    for i = #efeitoTexto, 1, -1 do
        local efeito = efeitoTexto[i]
        efeito.y = efeito.y - efeito.velocidade * dt
        efeito.tempoVida = efeito.tempoVida - dt
        if efeito.tempoVida <= 0 then
            table.remove(efeitoTexto, i)
        end
    end
end

local font = love.graphics.newFont("font/PressStart2P-Regular.ttf", 10)

function desenharEfeitosDeTexto()
    for _, efeito in ipairs(efeitoTexto) do
        drawTextWithBorder(efeito.texto, efeito.x, efeito.y, font, {1, 1, 1}, {0, 0, 0}, 1)
    end
end

function functionProjetile.handleProjectileCollisions(players, objetos, objetosInquebravel, objetosCenario)
    local todosObjetos = {}
    for _, obj in ipairs(objetos) do table.insert(todosObjetos, obj) end
    for _, obj in ipairs(objetosInquebravel) do table.insert(todosObjetos, obj) end
    for _, obj in ipairs(objetosCenario) do table.insert(todosObjetos, obj) end

    local explosionRadiusObj = 80
    local explosionRadiusCenario = 120
    local knockbackForce = 300

    local function aplicarDanoEKnockback(target, proj, dano)
        local danoRecebido = math.max(target.life - dano, 0)
        local vidaPerdida = target.life - danoRecebido
        target.life = danoRecebido
        criarEfeitoTexto(target.x, target.y - 20, vidaPerdida)

        target.knockbackX = (proj.x < target.x) and knockbackForce or -knockbackForce
        target.knockbackY = (proj.y < target.y) and knockbackForce or -knockbackForce
    end

    for _, player in ipairs(players) do
        for i = #player.projectiles, 1, -1 do
            local proj = player.projectiles[i]
            local colidiu = false

            for _, target in ipairs(players) do
                if target.visible and target ~= player and functionProjetile.checkCollisionWithPlayer(proj, target) then
                    table.remove(player.projectiles, i)
                    efeitoSonoro:play("sounds/soundeffect/explosion2.wav")
                    criarExplosao(proj.x, proj.y)

                    aplicarDanoEKnockback(target, proj, proj.damage)

                    for j = #objetos, 1, -1 do
                        local dx = objetos[j].x - proj.x
                        local dy = objetos[j].y - proj.y
                        if dx * dx + dy * dy <= explosionRadiusObj * explosionRadiusObj then
                            table.remove(objetos, j)
                        end
                    end

                    for j = #objetosCenario, 1, -1 do
                        local dx = objetosCenario[j].x - proj.x
                        local dy = objetosCenario[j].y - proj.y
                        if dx * dx + dy * dy <= explosionRadiusCenario * explosionRadiusCenario then
                            table.remove(objetosCenario, j)
                        end
                    end

                    for _, other in ipairs(players) do
                        if other ~= target and other.visible then
                            local dx = other.x - proj.x
                            local dy = other.y - proj.y
                            if dx * dx + dy * dy <= explosionRadiusObj * explosionRadiusObj then
                                local danoProx = calcularDanoPorProximidade(proj, other)
                                aplicarDanoEKnockback(other, proj, danoProx)
                            end
                        end
                    end

                    colidiu = true
                    break
                end
            end

            if not colidiu then

                local collidedWithObject = false
                for _, objeto in ipairs(todosObjetos) do
                    if functionProjetile.checkCollisionProjectile(proj, objeto) then
                        table.remove(player.projectiles, i)
                        efeitoSonoro:play("sounds/soundeffect/explosion2.wav")
                        criarExplosao(proj.x, proj.y)

                        for j = #objetos, 1, -1 do
                            local dx = objetos[j].x - proj.x
                            local dy = objetos[j].y - proj.y
                            if dx * dx + dy * dy <= explosionRadiusObj * explosionRadiusObj then
                                table.remove(objetos, j)
                            end
                        end

                        for j = #objetosCenario, 1, -1 do
                            local dx = objetosCenario[j].x - proj.x
                            local dy = objetosCenario[j].y - proj.y
                            if dx * dx + dy * dy <= explosionRadiusCenario * explosionRadiusCenario then
                                table.remove(objetosCenario, j)
                            end
                        end

                        for _, target in ipairs(players) do
                            if target.visible then
                                local dx = target.x - proj.x
                                local dy = target.y - proj.y
                                if dx * dx + dy * dy <= explosionRadiusObj * explosionRadiusObj then
                                    local danoProx = calcularDanoPorProximidade(proj, target)
                                    aplicarDanoEKnockback(target, proj, danoProx)
                                end
                            end
                        end
                        collidedWithObject = true
                        break
                    end
                end
            end
        end
    end
end

function functionProjetile.update(dt)
    atualizarExplosoes(dt)
    atualizarEfeitosDeTexto(dt)
end

function functionProjetile.draw()
    desenharExplosoes()
    desenharEfeitosDeTexto()
end

return functionProjetile
