local AssetManager = require("managers.asset_manager")

local Background = {}

function Background:init()
    self.image = AssetManager:getImage("background")
    self:createParticles()
end

function Background:createParticles()
    self.particles = {}
    local particleCount = 15
    
    for i = 1, particleCount do
        table.insert(self.particles, {
            x = love.math.random() * love.graphics.getWidth(),
            y = love.math.random() * love.graphics.getHeight(),
            speed = love.math.random() * 30 + 20,
            size = love.math.random() * 2 + 1,
            transparency = love.math.random() * 0.2 + 0.05
        })
    end
end

function Background:update(dt)
    for _, particle in ipairs(self.particles) do
        particle.y = particle.y + particle.speed * dt
        
        if particle.y > love.graphics.getHeight() + particle.size then
            particle.y = -particle.size
            particle.x = love.math.random() * love.graphics.getWidth()
        end
    end
end

function Background:draw()
    if self.image then
        love.graphics.setColor(1, 1, 1)
        local scaleX = love.graphics.getWidth() / self.image:getWidth()
        local scaleY = love.graphics.getHeight() / self.image:getHeight()
        love.graphics.draw(self.image, 0, 0, 0, scaleX, scaleY)
    else
        love.graphics.setColor(0.05, 0.05, 0.15)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    
    self:drawCenterLine()
    self:drawParticles()
end

function Background:drawCenterLine()
    love.graphics.setColor(1, 1, 1, 0.3)
    local centerX = love.graphics.getWidth() / 2
    local segmentHeight = 15
    local segmentGap = 10
    
    for y = 0, love.graphics.getHeight(), segmentHeight + segmentGap do
        love.graphics.rectangle("fill", centerX - 2, y, 4, segmentHeight)
    end
end

function Background:drawParticles()
    for _, particle in ipairs(self.particles) do
        love.graphics.setColor(1, 1, 1, particle.transparency)
        love.graphics.circle("fill", particle.x, particle.y, particle.size)
    end
end

return Background