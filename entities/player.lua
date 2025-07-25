local AssetManager = require("managers.asset_manager")
local Constants = require("constants")
local Utils = require("utils")

local Player = {}

function Player:init()
    self.x = Constants.PLAYER_X
    self.speed = Constants.PLAYER_SPEED
    
    self.image = AssetManager:getImage("player")
    
    if self.image then
        self.width = self.image:getWidth()
        self.height = self.image:getHeight()
    else
        self.width = Constants.PLAYER_FALLBACK_WIDTH
        self.height = Constants.PLAYER_FALLBACK_HEIGHT
    end
    
    self:reset()
end

function Player:reset()
    self.y = (Constants.SCREEN_HEIGHT - self.height) / 2
end

function Player:update(dt)
    self:handleInput(dt)
    self:checkBoundaries()
end

function Player:handleInput(dt)
    local movement = 0
    
    if love.keyboard.isDown("w", "up") then
        movement = movement - 1
    end
    if love.keyboard.isDown("s", "down") then
        movement = movement + 1
    end
    
    self.y = self.y + movement * self.speed * dt
end

function Player:checkBoundaries()
    self.y = Utils.clamp(self.y, 0, Constants.SCREEN_HEIGHT - self.height)
end

function Player:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    
    if self.image then
        love.graphics.draw(self.image, self.x, self.y)
    else
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

return Player