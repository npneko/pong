local AssetManager = require("managers.asset_manager")
local LevelManager = require("managers.level_manager")

local Constants = require("constants")
local Utils = require("utils")

local Computer = {}

function Computer:init()
    self.x = Constants.SCREEN_WIDTH - Constants.COMPUTER_X_OFFSET
    self.image = AssetManager:getImage("computer")
    
    if self.image then
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
        self.x = Constants.SCREEN_WIDTH - self.width - (Constants.COMPUTER_X_OFFSET - Constants.COMPUTER_FALLBACK_WIDTH)
    else
        self.width = Constants.COMPUTER_FALLBACK_WIDTH
        self.height = Constants.COMPUTER_FALLBACK_HEIGHT
    end
    
    self:reset()
    self:updateDifficulty()
end

function Computer:reset()
    self.y = (Constants.SCREEN_HEIGHT - self.height) / 2
    self.targetY = self.y
    self.updateTimer = 0
    self.reactionTimer = 0
    self.lastBallDirection = 0
end

function Computer:updateDifficulty()
    local levelData = LevelManager:getCurrentLevelData()
    self.maxSpeed = levelData.computerSpeed
    self.difficulty = levelData.computerDifficulty
    self.reactionTime = levelData.computerReactionTime
    self.updateRate = 0.3
end

function Computer:update(dt, ball)
    self.updateTimer = self.updateTimer + dt
    self.reactionTimer = self.reactionTimer + dt
    
    if self.updateTimer >= self.updateRate then
        self.updateTimer = 0
        self:updateTarget(ball)
    end
    
    self:moveTowardsTarget(dt)
    self:checkBoundaries()
end

function Computer:updateTarget(ball)
    if not ball then return end
    
    local ballDirection = ball.xVelocity > 0 and 1 or -1
    if ballDirection ~= self.lastBallDirection then
        self.reactionTimer = 0
        self.lastBallDirection = ballDirection
    end
    
    if self.reactionTimer < self.reactionTime then
        return
    end
    
    if ball.xVelocity > 0 then
        local ballCenterY = ball.y + ball.height / 2
        local maxError = (1 - self.difficulty) * 150
        local error = (love.math.random() - 0.5) * 2 * maxError
        
        local trackingY
        if self.difficulty < 0.6 then
            trackingY = ballCenterY + error
        else
            local predictedY = self:simplePrediction(ball)
            trackingY = predictedY + error
        end
        
        self.targetY = trackingY - self.height / 2
    else
        local centerY = (Constants.SCREEN_HEIGHT - self.height) / 2
        self.targetY = self.y + (centerY - self.y) * 0.1
    end
end

function Computer:simplePrediction(ball)
    if ball.xVelocity <= 0 then
        return ball.y + ball.height / 2
    end
    
    local timeToReach = (self.x - ball.x - ball.width) / ball.xVelocity
    timeToReach = math.max(0, timeToReach)
    
    local predictedY = ball.y + ball.yVelocity * timeToReach
    
    if predictedY < 0 then
        predictedY = math.abs(predictedY)
    elseif predictedY > Constants.SCREEN_HEIGHT then
        predictedY = Constants.SCREEN_HEIGHT - (predictedY - Constants.SCREEN_HEIGHT)
    end
    
    return Utils.clamp(predictedY, ball.height / 2, Constants.SCREEN_HEIGHT - ball.height/2)
end

function Computer:moveTowardsTarget(dt)
    local difference = self.targetY - self.y
    local deadZone = 15
    
    if math.abs(difference) > deadZone then
        local direction = difference > 0 and 1 or -1
        local moveSpeed = self.maxSpeed * direction * self.difficulty
        
        if math.abs(difference) < 50 then
            moveSpeed = moveSpeed * 0.5
        end
        
        self.y = self.y + moveSpeed * dt
    end
end

function Computer:checkBoundaries()
    self.y = Utils.clamp(self.y, 0, Constants.SCREEN_HEIGHT - self.height)
    self.targetY = Utils.clamp(self.targetY, 0, Constants.SCREEN_HEIGHT - self.height)
end

function Computer:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function Computer:draw()
    love.graphics.setColor(1, 1, 1)
    
    if self.image then
        love.graphics.draw(self.image, self.x, self.y)
    else
        love.graphics.setColor(1, 0.8, 0.8)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

return Computer