local soundeffect = {}

soundeffect.effects = {}     -- Cache de efeitos carregados
soundeffect.volume = 0.5       -- Volume global dos efeitos
soundeffect.playing = {}     -- Lista de efeitos atualmente tocando

-- Carrega ou reutiliza o efeito sonoro
function soundeffect:load(path)
    if not self.effects[path] then
        self.effects[path] = love.audio.newSource(path, "static")
    end
    return self.effects[path]:clone() -- Clona para sobreposição
end

-- Toca um efeito sonoro (sempre toca, sobrepondo se necessário)
function soundeffect:play(path)
    local sound = self:load(path)
    sound:setVolume(self.volume)
    sound:play()

    table.insert(self.playing, sound)
end

-- Atualiza e remove sons que terminaram
function soundeffect:update()
    for i = #self.playing, 1, -1 do
        if not self.playing[i]:isPlaying() then
            table.remove(self.playing, i)
        end
    end
end

-- Altera o volume global dos efeitos
function soundeffect:setVolume(v)
    self.volume = math.max(0, math.min(1, v))
end

-- Para todos os efeitos em execução
function soundeffect:stopAll()
    for _, source in ipairs(self.playing) do
        source:stop()
    end
    self.playing = {}
end

return soundeffect
