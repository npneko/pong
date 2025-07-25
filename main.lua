local AssetManager = require("managers.asset_manager")
local SoundManager = require("managers.sound_manager")
local LevelManager = require("managers.level_manager")

local GameState = require("systems.game_state")
local Background = require("systems.background")
local Score = require("systems.score")

local Player = require("entities.player")
local Computer = require("entities.computer")
local Ball = require("entities.ball")

local gameState
local player
local ball
local computer
local background
local score

function love.load()
    AssetManager:init()
    SoundManager:init()
    LevelManager:init()
    
    gameState = GameState
    player = Player
    ball = Ball
    computer = Computer
    background = Background
    score = Score
    
    gameState:init()
    player:init()
    ball:init()
    computer:init()
    background:init()
    score:init()
    
    gameState:setModules(ball, score)
    gameState:setState("menu")
end

function love.update(dt)
    background:update(dt)
    gameState:update(dt)
    
    if gameState:getState() == "playing" then
        player:update(dt)
        computer:update(dt, ball)
        ball:update(dt, gameState, player, computer, score)
        score:update(dt)
        
        if score:hasWinner() then
            gameState:checkGameOver()
        end
    elseif gameState:getState() == "levelselect" then
        computer:updateDifficulty()
    end
end

function love.draw()
    background:draw()
    
    local state = gameState:getState()
    
    if state == "playing" or state == "paused" or state == "gameover" then
        player:draw()
        ball:draw()
        computer:draw()
        score:draw()
        
        if state == "playing" then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.setFont(AssetManager:getFont("small"))
            local levelText = "Level: " .. LevelManager:getCurrentLevelName()
            love.graphics.print(levelText, 10, love.graphics.getHeight() - 30)
        end
    end
    
    gameState:draw()
end

function love.keypressed(key)
    if key == "m" then
        SoundManager:toggle()
        return
    end
    
    gameState:keypressed(key)
end