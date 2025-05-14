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
    
    for i = 1, 40 do
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

function functionProjetile.handleProjectileCollisions(players, objetos, objetosInquebravel, objetosCenario)
    for _, player in ipairs(players) do
        for i = #player.projectiles, 1, -1 do
            local proj = player.projectiles[i]

            local todosObjetos = {}
            for _, obj in ipairs(objetos) do
                table.insert(todosObjetos, obj)
            end
            for _, objInq in ipairs(objetosInquebravel) do
                table.insert(todosObjetos, objInq)
            end
            for _, objCen in ipairs(objetosCenario) do
                table.insert(todosObjetos, objCen)
            end

            for _, objeto in ipairs(todosObjetos) do
                if functionProjetile.checkCollisionProjectile(proj, objeto) then
                    table.remove(player.projectiles, i)
                    efeitoSonoro:play("sounds/soundeffect/explosion2.wav")
                    criarExplosao(proj.x, proj.y)

                    for j = #objetos, 1, -1 do
                        local objeto2 = objetos[j]
                        local dist = math.sqrt((objeto2.x - proj.x)^2 + (objeto2.y - proj.y)^2)
                        if dist <= 80 then
                            table.remove(objetos, j)
                        end
                    end

                    for j = #objetosCenario, 1, -1 do
                        local objeto3 = objetosCenario[j]
                        local dist = math.sqrt((objeto3.x - proj.x)^2 + (objeto3.y - proj.y)^2)
                        if dist <= 120 then
                            table.remove(objetosCenario, j)
                        end
                    end

                    for _, target in ipairs(players) do
                        if target.visible then
                            local distPlayer = math.sqrt((target.x - proj.x)^2 + (target.y - proj.y)^2)
                            if distPlayer <= 80 then
                                local dano = calcularDanoPorProximidade(proj, target)
                                local danoRecebido = math.max(target.life - dano, 0)
                                local vidaPerdida = target.life - danoRecebido
                                target.life = danoRecebido
                                criarEfeitoTexto(target.x, target.y - 20, vidaPerdida)

                                local knockbackForce = 300
                                if proj.x < target.x then
                                    target.knockbackX = knockbackForce
                                else
                                    target.knockbackX = -knockbackForce
                                end

                                if proj.y < target.y then
                                    target.knockbackY = knockbackForce
                                else
                                    target.knockbackY = -knockbackForce
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end

function calcularDanoPorProximidade(proj, target)
    local dist = math.sqrt((target.x - proj.x)^2 + (target.y - proj.y)^2)
    local danoMaximo = target.damage
    local distanciaMaxima = 100
    local danoFinal = math.max(danoMaximo * (1 - dist / distanciaMaxima), 0)
    return math.floor(danoFinal)
end


function criarEfeitoTexto(x, y, vidaPerdida)
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

function desenharEfeitosDeTexto()
    for _, efeito in ipairs(efeitoTexto) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(efeito.texto, efeito.x, efeito.y)
    end
end

return functionProjetile
