local debug = {}

function debug.load()
    debug.largura = 1920
    debug.altura = 1080
    debug.tamanhoQuadrado = 16
end

function debug.draw(debugAtivo)
    if debugAtivo then  
        love.graphics.setColor(0.8, 0.8, 0.8, 0.7)  

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
end



return debug