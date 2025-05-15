local creditos = {}
local lineSpacing = 4.4
local font = nil
local background = nil
local creditText = [[
DESENVOLVIMENTO E CRIAÇÃO

GAME DESIGNER PRINCIPAL:
Jean Pasquini
Amanda

PROGRAMADORES:
Filipi Biazoto
Jean Pasquini

DESIGN DE PERSONAGENS E ARTE:
Amanda

MÚSICA E EFEITOS SONOROS:
Filipi Biazoto

TESTADORES DE QUALIDADE (QA):
Jean Pasquini
Filipi Biazoto

FERRAMENTAS E TECNOLOGIAS UTILIZADAS

Engine: Love2D
Linguagem: Lua
IDE: Visual Studio Code / ZeroBrane
Editor de PixelArt: Aseprite
Editor de Imagem: Canva / Krita
Sistema de Controle de Versão: Git & GitHub
Sistema de Documentação: Trello

RECURSOS E SITES UTILIZADOS

Love2d (Wiki)
Itch.io  (assets gratuitos e sons)
Freepik (elementos gráficos)
OpenGameArt (elementos gráficos e sons)
CraftPix (elementos gráficos)
FontSpace (tipografias)
ChatGPT (elementos gráficos e assets)

AGRADECIMENTOS ESPECIAIS

Amanda, forneceu muita colaboração pelas artes e seu conhecimento em game designer.
GitHub Community, ajudou em consultas e ideias para melhorarmos o nosso progressos.

AGRADECIMENTO A TODO CORPO DOCENTE:
- José Tarcísio
- Raul Donaire

AGRADECIMENTO POR FORA:
- David Buzzato
- Familiares e amigos

EQUIPE DE PRODUÇÃO

PRODUTOR EXECUTIVO:
Jean Pasquini

DIRETOR DE ARTE:
Amanda

COORDENAÇÃO TÉCNICA:
Filipi Biazoto

VERSÃO DO JOGO:
V1.0.0

DATA DE LANÇAMENTO:
03 DE JUNHO DE 2025

]]

-- Variáveis de controle (mantidas fora do load)
local yOffset = nil
local scrollSpeed = 90
local totalTextHeight = 0
local finished = false
local pularBotao = {}
local mouseX, mouseY = 0, 0
local foiCarregado = false

function creditos.reset()
    foiCarregado = false
    yOffset = nil
    finished = false
end

function creditos.load()
    -- if foiCarregado then return end

    -- Só define como carregado no final
    local successFont = pcall(function()
        font = love.graphics.newFont("font/PressStart2P-Regular.ttf", 14)
    end)

    local successBackground = pcall(function()
        background = love.graphics.newImage("resources/backgrounds/background5.png")
    end)

    if not (successFont and successBackground and background and font) then
        print("[ERRO] Falha ao carregar fonte ou background em creditos.lua")
        return
    end

    local lineCount = 0
    for _ in creditText:gmatch("[^\r\n]+") do
        lineCount = lineCount + 1
    end
    totalTextHeight = lineCount * font:getHeight()

    yOffset = love.graphics.getHeight() * 1
    finished = false


    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local largura = screenWidth * 0.2
    local altura = screenHeight * 0.08
    local x = screenWidth - largura - 30
    local y = screenHeight - altura - 30

    pularBotao = {
        texto = "PULAR",
        x = x,
        y = y,
        largura = largura,
        altura = altura,
        hover = false,
        acao = function()
            trocarEstado("menu")
        end
    }

    -- Agora sim: carregamento completo com sucesso
    --foiCarregado = true
end

local function drawBackground()
    local ww, wh = love.graphics.getDimensions()
    local bgWidth, bgHeight = background:getDimensions()
    local scale = math.max(ww / bgWidth, wh / bgHeight)
    love.graphics.draw(background, 0, 0, 0, scale, scale)
end

function creditos.update(dt)

    print("Rodando update dos créditos")

    if not yOffset then return end

    yOffset = yOffset - scrollSpeed * dt
    if yOffset + totalTextHeight < -1800 and not finished then
        finished = true
        trocarEstado("menu")
    end

end

function creditos.draw()
    drawBackground()

    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 1) -- força cor branca visível

    local screenWidth = love.graphics.getWidth()
    local y = yOffset

    local i = 0

    if not background or not font then
        print("[ERRO] Recursos de crédito não carregados corretamente")
        return
    end

    for line in creditText:gmatch("[^\r\n]+") do
        local textWidth = font:getWidth(line)
        local x = (screenWidth - textWidth) / 2

        love.graphics.print(line, x, y)
        y = y + font:getHeight() * lineSpacing
        
    end

    -- desenhar botão "PULAR"
    -- botão "PULAR"
    if pularBotao.hover then
        love.graphics.setColor(0.42, 0.7, 0.42) -- Hover: verde claro
    else
        love.graphics.setColor(0.29, 0.5, 0.29) -- Normal: verde escuro
    end
    love.graphics.rectangle("fill", pularBotao.x, pularBotao.y, pularBotao.largura, pularBotao.altura)

    love.graphics.setColor(1, 1, 0.6) -- borda
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", pularBotao.x, pularBotao.y, pularBotao.largura, pularBotao.altura)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.printf(pularBotao.texto, pularBotao.x, pularBotao.y + (pularBotao.altura / 2) - 10, pularBotao.largura, "center")


end

function creditos.keypressed(key)
    if key == "escape" or key == "return" then
        trocarEstado("menu")
    end
end

function creditos.mousepressed(x, y, button)
    if button == 1 then
        if x > pularBotao.x and x < pularBotao.x + pularBotao.largura and
           y > pularBotao.y and y < pularBotao.y + pularBotao.altura then
            pularBotao.acao()
        end
    end
end

function creditos.mousemoved(x, y)
    pularBotao.hover =
        x > pularBotao.x and x < pularBotao.x + pularBotao.largura and
        y > pularBotao.y and y < pularBotao.y + pularBotao.altura
end

return creditos