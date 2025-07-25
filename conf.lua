local Constants = require("constants")

function love.conf(t)
    t.title = "Pong"
    t.version = "11.5"
    t.window.width = Constants.SCREEN_WIDTH
    t.window.height = Constants.SCREEN_HEIGHT
    t.window.resizable = false
    t.window.vsync = 1
    t.modules.joystick = false
    t.modules.physics = false
end