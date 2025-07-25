local AssetManager = require("managers.asset_manager")
local SoundManager = require("managers.sound_manager")
local Constants = require("constants")

local Score = {}

function Score:init()
    self.maxScore = Constants.MAX_SCORE
    self:reset()
end

function Score:reset()
    self.player = 0
    self.computer = 0
end

function Score:update(dt)
    -- Empty but kept for consistency
end

function Score:playerScored()
    self.player = self.player + 1
    SoundManager:playSound("score")
end

function Score:aiScored()
    self.computer = self.computer + 1
    SoundManager:playSound("score")
end

function Score:hasWinner()
    return self.player >= self.maxScore or self.computer >= self.maxScore
end

function Score:getWinner()
    if self.player >= self.maxScore then
        return "PLAYER"
    elseif self.computer >= self.maxScore then
        return "COMPUTER"
    end
    return nil
end

function Score:draw()
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.setFont(AssetManager:getFont("huge"))
    
    local centerX = love.graphics.getWidth() / 2
    local scoreY = 50
    
    love.graphics.printf(tostring(self.player), centerX - 200, scoreY, 100, "center")
    love.graphics.printf(tostring(self.computer), centerX + 100, scoreY, 100, "center")
end

return Score