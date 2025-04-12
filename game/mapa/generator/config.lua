local Objeto = require("mapa.library.objeto")
local Agua = require("mapa.library.agua")
local config = {}

function config.load()
    config.largura = 1920
    config.altura = 1080
    config.tamanhoQuadrado = 16
    config.matriz = require("mapa.mapa1.matriz")        -- Matriz de valores (0, 1, 2...)
    config.imagemMatriz = require("mapa.mapa1.matrizTiles")  -- Matriz de imagens associadas ao objeto
    config.cores = {
        [0] = {0.25, 0.25, 0.25},  -- Cor para valor 0
        [1] = {0, 1, 0},           -- Cor para valor 1 (verde)
        [2] = {0, 0, 1}            -- Cor para valor 2 (azul)
    }

    config.maxQuadradosPorLinha = math.floor(config.largura / config.tamanhoQuadrado)
    config.objetos = {}
    config.aguas = {}
    
    for y, linha in ipairs(config.matriz) do
        for x, valor in ipairs(linha) do
            -- Pegue o valor da imagem associada à posição (x, y)
            local imagemValor = config.imagemMatriz[y] and config.imagemMatriz[y][x] or nil

            -- Verifique o tipo de valor na matriz
            if valor == 1 then
                  local px = (x - 1) % config.maxQuadradosPorLinha * config.tamanhoQuadrado
                  local py = math.floor((x - 1) / config.maxQuadradosPorLinha) * config.tamanhoQuadrado
                  local objeto = Objeto.new(px, py, imagemValor)  -- Passando a imagem da grama
                  table.insert(config.objetos, objeto)
            elseif valor == 2 then
                -- Água
                local px = (x - 1) % config.maxQuadradosPorLinha * config.tamanhoQuadrado
                local py = math.floor((x - 1) / config.maxQuadradosPorLinha) * config.tamanhoQuadrado
                local agua = Agua.new(px, py)  -- Passe imagemValor para a água
                table.insert(config.aguas, agua)
            end
        end
    end
end

function config.draw()
    local numQuadrados = 0

    for y, linha in ipairs(config.matriz) do
        for x, valor in ipairs(linha) do
            local px = (numQuadrados % config.maxQuadradosPorLinha) * config.tamanhoQuadrado
            local py = math.floor(numQuadrados / config.maxQuadradosPorLinha) * config.tamanhoQuadrado

            local cor = config.cores[valor]
            if cor then
                love.graphics.setColor(cor[1], cor[2], cor[3]) 
            else
                love.graphics.setColor(1, 1, 1) 
            end
            
            love.graphics.rectangle("fill", px, py, config.tamanhoQuadrado, config.tamanhoQuadrado)

            numQuadrados = numQuadrados + 1
        end
    end

    for _, objeto in ipairs(config.objetos) do
        objeto:draw()
    end
end

return config
