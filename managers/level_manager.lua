local Constants = require("constants")

local LevelManager = {}

function LevelManager:init()
    self.currentLevel = 1
    self.totalLevels = #Constants.LEVELS
end

function LevelManager:getCurrentLevel()
    return self.currentLevel
end

function LevelManager:getCurrentLevelData()
    return Constants.LEVELS[self.currentLevel]
end

function LevelManager:getCurrentLevelName()
    return Constants.LEVELS[self.currentLevel].name
end

function LevelManager:nextLevel()
    if self.currentLevel < self.totalLevels then
        self.currentLevel = self.currentLevel + 1
        return true
    end
    return false
end

function LevelManager:previousLevel()
    if self.currentLevel > 1 then
        self.currentLevel = self.currentLevel - 1
        return true
    end
    return false
end

function LevelManager:hasNextLevel()
    return self.currentLevel < self.totalLevels
end

function LevelManager:hasPreviousLevel()
    return self.currentLevel > 1
end

return LevelManager