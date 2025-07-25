local AssetManager = require("managers.asset_manager")

local SoundManager = {}

function SoundManager:init()
    self.volume = 0.7
    self.enabled = true
end

function SoundManager:playSound(soundName)
    if not self.enabled then return end
    
    local sound = AssetManager:getSound(soundName)
    if sound then
        sound:setVolume(self.volume)
        love.audio.play(sound)
    end
end

function SoundManager:toggle()
    self.enabled = not self.enabled
end

return SoundManager