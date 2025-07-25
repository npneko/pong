local AssetManager = require("managers.asset_manager")
local LevelManager = require("managers.level_manager")

local GameState = {}

function GameState:init()
    self.state = "menu"
    self.menuSelection = 1
    self.maxMenuOptions = 3
    
    self.ball = nil
    self.score = nil
end

function GameState:setModules(ball, score)
    self.ball = ball
    self.score = score
end

function GameState:getState()
    return self.state
end

function GameState:setState(newState)
    self.state = newState
    
    if newState == "playing" then
        if self.ball then self.ball:reset() end
        if self.score then self.score:reset() end
    elseif newState == "menu" then
        self.menuSelection = 1
    elseif newState == "levelselect" then
        self.levelSelection = LevelManager:getCurrentLevel()
    end
end

function GameState:update(dt)
    -- Empty but kept for consistency
end

function GameState:draw()
    if self.state == "menu" then
        self:drawMenu()
    elseif self.state == "levelselect" then
        self:drawLevelSelect()
    elseif self.state == "paused" then
        self:drawPauseMenu()
    elseif self.state == "gameover" then
        self:drawGameOver()
    end
end

function GameState:drawMenu()
    local font = AssetManager:getFont("large")
    local mediumFont = AssetManager:getFont("medium")
    local smallFont = AssetManager:getFont("small")
    
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    
    local centerX = love.graphics.getWidth() / 2
    local centerY = love.graphics.getHeight() / 2
    
    love.graphics.printf("PONG", centerX - 100, centerY - 150, 200, "center")
    
    love.graphics.setFont(mediumFont)
    
    local options = {"Start Game", "Select Level", "Quit"}
    for i, option in ipairs(options) do
        local color = (i == self.menuSelection) and {1, 1, 0} or {1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.printf(option, centerX - 100, centerY - 50 + (i-1) * 40, 200, "center")
    end
    
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Use W/S to move, SPACE to pause", centerX - 150, centerY + 100, 300, "center")
end

function GameState:drawLevelSelect()
    local font = AssetManager:getFont("large")
    local mediumFont = AssetManager:getFont("medium")
    local smallFont = AssetManager:getFont("small")
    
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    
    local centerX = love.graphics.getWidth() / 2
    local centerY = love.graphics.getHeight() / 2
    
    love.graphics.printf("SELECT LEVEL", centerX - 150, centerY - 150, 300, "center")
    
    love.graphics.setFont(mediumFont)
    local levelData = LevelManager:getCurrentLevelData()
    local levelText = string.format("%d. %s", LevelManager:getCurrentLevel(), levelData.name)
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.printf(levelText, centerX - 100, centerY - 50, 200, "center")
    
    love.graphics.setColor(1, 1, 1)
    if LevelManager:hasPreviousLevel() then
        love.graphics.printf("<", centerX - 150, centerY - 50, 50, "center")
    end
    if LevelManager:hasNextLevel() then
        love.graphics.printf(">", centerX + 100, centerY - 50, 50, "center")
    end
    
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf("A/D or Left/Right to change level", centerX - 150, centerY + 50, 300, "center")
    love.graphics.printf("ENTER to start, ESC to return", centerX - 150, centerY + 80, 300, "center")
end

function GameState:drawPauseMenu()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(AssetManager:getFont("large"))
    love.graphics.printf("PAUSED", 0, love.graphics.getHeight()/2 - 50, love.graphics.getWidth(), "center")
    
    love.graphics.setFont(AssetManager:getFont("medium"))
    love.graphics.printf("Press SPACE to resume or ESC for menu", 0, love.graphics.getHeight()/2 + 20, love.graphics.getWidth(), "center")
end

function GameState:drawGameOver()
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(AssetManager:getFont("large"))
    
    local winner = self.score and self.score:getWinner()
    if winner then
        love.graphics.printf(winner .. " WINS!", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    end
    
    love.graphics.setFont(AssetManager:getFont("medium"))
    love.graphics.printf("Press R to restart or ESC for menu", 0, love.graphics.getHeight()/2 + 20, love.graphics.getWidth(), "center")
end

function GameState:keypressed(key)
    if self.state == "menu" then
        self:handleMenuInput(key)
    elseif self.state == "levelselect" then
        self:handleLevelSelectInput(key)
    elseif self.state == "playing" then
        self:handlePlayingInput(key)
    elseif self.state == "paused" then
        self:handlePausedInput(key)
    elseif self.state == "gameover" then
        self:handleGameOverInput(key)
    end
end

function GameState:handleMenuInput(key)
    if key == "up" or key == "w" then
        self.menuSelection = math.max(1, self.menuSelection - 1)
    elseif key == "down" or key == "s" then
        self.menuSelection = math.min(self.maxMenuOptions, self.menuSelection + 1)
    elseif key == "return" or key == "space" then
        if self.menuSelection == 1 then
            self:setState("playing")
        elseif self.menuSelection == 2 then
            self:setState("levelselect")
        else
            love.event.quit()
        end
    end
end

function GameState:handleLevelSelectInput(key)
    if key == "left" or key == "a" then
        if LevelManager:hasPreviousLevel() then
            LevelManager:previousLevel()
        end
    elseif key == "right" or key == "d" then
        if LevelManager:hasNextLevel() then
            LevelManager:nextLevel()
        end
    elseif key == "return" or key == "space" then
        self:setState("playing")
    elseif key == "escape" then
        self:setState("menu")
    end
end

function GameState:handlePlayingInput(key)
    if key == "space" then
        self:setState("paused")
    elseif key == "escape" then
        self:setState("menu")
    end
end

function GameState:handlePausedInput(key)
    if key == "space" then
        self:setState("playing")
    elseif key == "escape" then
        self:setState("menu")
    end
end

function GameState:handleGameOverInput(key)
    if key == "r" then
        self:setState("playing")
    elseif key == "escape" then
        self:setState("menu")
    end
end

function GameState:checkGameOver()
    if self.score and self.score:hasWinner() then
        self:setState("gameover")
    end
end

return GameState
