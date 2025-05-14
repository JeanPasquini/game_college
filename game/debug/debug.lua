local debug = {}

debug.fontePequena = love.graphics.newFont(10)

function debug.load()
    debug.largura = 1920
    debug.altura = 1080
    debug.tamanhoQuadrado = 16
end

function debug.draw(debugAtivo, player)
    if debugAtivo then  
        love.graphics.setColor(0.8, 0.8, 0.8, 0.2)  

        for i = 0, debug.largura / debug.tamanhoQuadrado - 1 do
            for j = 0, debug.altura / debug.tamanhoQuadrado - 1 do
                love.graphics.rectangle(
                    "line",  
                    i * debug.tamanhoQuadrado,  
                    j * debug.tamanhoQuadrado,  
                    debug.tamanhoQuadrado,      
                    debug.tamanhoQuadrado       
                )
            end
        end
    end

    if player and debugAtivo then
      love.graphics.setFont(debug.fontePequena)
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("Velocidade Y: " .. string.format("%.2f", player.velocidadeY), player.x + 20, player.y - 40)
      love.graphics.print("Força: " .. string.format("%.2f", player.forcaTiro), player.x + 20, player.y - 60)
      love.graphics.print("Pulando: " .. tostring(player.pulando), player.x + 20, player.y - 80)
      love.graphics.print("Disparou: " .. tostring(player.disparou), player.x + 20, player.y - 100)
      love.graphics.setFont(love.graphics.newFont())
    end
end




return debug