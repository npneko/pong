local AssetManager = require("managers.asset_manager")
local SoundManager = require("managers.sound_manager")
local LevelManager = require("managers.level_manager")

local Constants = require("constants")
local Utils = require("utils")

local Ball = {}

function Ball:init()
    self.image = AssetManager:getImage("ball")
    
    if self.image then
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
    else
        self.width = Constants.BALL_FALLBACK_SIZE
        self.height = Constants.BALL_FALLBACK_SIZE
    end
    
    self.maxSpeed = Constants.BALL_MAX_SPEED
    self.speedIncrease = Constants.BALL_SPEED_INCREASE
    
    self:reset()
end

function Ball:reset()
    self.x = (Constants.SCREEN_WIDTH - self.width) / 2
    self.y = (Constants.SCREEN_HEIGHT - self.height) / 2
    
    local levelData = LevelManager:getCurrentLevelData()
    self.speed = levelData.ballSpeed
    
    local angle = love.math.random() * math.pi / 4 - math.pi / 8
    if love.math.random() > 0.5 then
        angle = angle + math.pi
    end
    
    self.xVelocity = math.cos(angle) * self.speed
    self.yVelocity = math.sin(angle) * self.speed
end

function Ball:update(dt, gameState, player, computer, score)
    if gameState:getState() ~= "playing" then
        return
    end
    
    self:move(dt)
    self:checkCollisions(player, computer, score)
end

function Ball:move(dt)
    self.x = self.x + self.xVelocity * dt
    self.y = self.y + self.yVelocity * dt
end

function Ball:checkCollisions(player, computer, score)
    self:collideWithWalls()
    self:collideWithPlayer(player)
    self:collideWithAI(computer)
    self:checkScore(score)
end

function Ball:collideWithWalls()
    if self.y <= 0 then
        self.y = 0
        self.yVelocity = math.abs(self.yVelocity)
        SoundManager:playSound("wall_hit")
    elseif self.y + self.height >= Constants.SCREEN_HEIGHT then
        self.y = Constants.SCREEN_HEIGHT - self.height
        self.yVelocity = -math.abs(self.yVelocity)
        SoundManager:playSound("wall_hit")
    end
end

function Ball:collideWithPlayer(player)
    if not player then return end
    
    local ballBounds = self:getBounds()
    local playerBounds = player:getBounds()
    
    if Utils.checkCollision(ballBounds, playerBounds) then
        self.x = player.x + player.width + 1
        self:calculateBounce(player)
        SoundManager:playSound("paddle_hit")
    end
end

function Ball:collideWithAI(computer)
    if not computer then return end
    
    local ballBounds = self:getBounds()
    local aiBounds = computer:getBounds()
    
    if Utils.checkCollision(ballBounds, aiBounds) then
        self.x = computer.x - self.width - 1
        self:calculateBounce(computer, true)
        SoundManager:playSound("paddle_hit")
    end
end

function Ball:calculateBounce(paddle, isAI)
    local ballCenter = self.y + self.height / 2
    local paddleCenter = paddle.y + paddle.height / 2
    local hitPos = (ballCenter - paddleCenter) / (paddle.height / 2)
    
    hitPos = Utils.clamp(hitPos, -1, 1)
    local bounceAngle = hitPos * math.pi / 4
    
    self.speed = math.min(self.speed * self.speedIncrease, self.maxSpeed)
    
    if isAI then
        self.xVelocity = -math.cos(bounceAngle) * self.speed
    else
        self.xVelocity = math.cos(bounceAngle) * self.speed
    end
    
    self.yVelocity = math.sin(bounceAngle) * self.speed
end

function Ball:checkScore(score)
    if not score then return end
    
    if self.x + self.width < 0 then
        score:aiScored()
        self:reset()
    elseif self.x > Constants.SCREEN_WIDTH then
        score:playerScored()
        self:reset()
    end
end

function Ball:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function Ball:draw()
    love.graphics.setColor(1, 1, 1)
    
    if self.image then
        love.graphics.draw(self.image, self.x, self.y)
    else
        love.graphics.circle("fill", self.x + self.width/2, self.y + self.height/2, self.width/2)
    end
end

return Ball
