local Constants = require("constants")

local AssetManager = {}
local images = {}
local sounds = {}
local fonts = {}

function AssetManager:init()
    self:loadImages()
    self:loadSounds()
    self:loadFonts()
end

function AssetManager:loadImages()
    local imageFiles = {
        "ball.png",
        "player.png",
        "computer.png",
        "background.png"
    }
    
    for _, filename in ipairs(imageFiles) do
        local path = Constants.ASSETS.IMAGES .. filename
        if love.filesystem.getInfo(path) then
            local name = filename:match("(.+)%.png")
            images[name] = love.graphics.newImage(path)
        end
    end
end

function AssetManager:loadSounds()
    local soundFiles = {
        "score.wav",
        "wall_hit.wav",
        "paddle_hit.wav"
    }
    
    for _, filename in ipairs(soundFiles) do
        local path = Constants.ASSETS.SOUNDS .. filename
        if love.filesystem.getInfo(path) then
            local name = filename:match("(.+)%.wav")
            sounds[name] = love.audio.newSource(path, "static")
        end
    end
end

function AssetManager:loadFonts()
    local fontPath = Constants.ASSETS.FONTS .. "Teko-SemiBold.ttf"
    
    if love.filesystem.getInfo(fontPath) then
        fonts["small"] = love.graphics.newFont(fontPath, 24)
        fonts["medium"] = love.graphics.newFont(fontPath, 32)
        fonts["large"] = love.graphics.newFont(fontPath, 48)
        fonts["huge"] = love.graphics.newFont(fontPath, 72)
    else
        fonts["small"] = love.graphics.newFont(24)
        fonts["medium"] = love.graphics.newFont(32)
        fonts["large"] = love.graphics.newFont(48)
        fonts["huge"] = love.graphics.newFont(72)
    end
end

function AssetManager:getImage(name)
    return images[name]
end

function AssetManager:getSound(name)
    return sounds[name]
end

function AssetManager:getFont(name)
    return fonts[name] or fonts["small"]
end

return AssetManager