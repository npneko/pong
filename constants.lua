local Constants = {
    SCREEN_WIDTH = 1024,
    SCREEN_HEIGHT = 768,
    
    MAX_SCORE = 5,
    
    PLAYER_SPEED = 400,
    PLAYER_X = 50,
    PLAYER_FALLBACK_WIDTH = 20,
    PLAYER_FALLBACK_HEIGHT = 100,
    
    COMPUTER_X_OFFSET = 70,
    COMPUTER_FALLBACK_WIDTH = 20,
    COMPUTER_FALLBACK_HEIGHT = 100,
    
    BALL_MAX_SPEED = 600,
    BALL_SPEED_INCREASE = 1.05,
    BALL_FALLBACK_SIZE = 16,
    
    LEVELS = {
        {
            name = "Easy",
            computerSpeed = 250,
            computerDifficulty = 0.5,
            computerReactionTime = 0.20,
            ballSpeed = 300
        },
        {
            name = "Medium",
            computerSpeed = 350,
            computerDifficulty = 0.75,
            computerReactionTime = 0.12,
            ballSpeed = 350
        },
        {
            name = "Hard",
            computerSpeed = 450,
            computerDifficulty = 0.85,
            computerReactionTime = 0.08,
            ballSpeed = 400
        },
        {
            name = "Expert",
            computerSpeed = 550,
            computerDifficulty = 0.95,
            computerReactionTime = 0.05,
            ballSpeed = 450
        }
    },
    
    ASSETS = {
        IMAGES = "assets/images/",
        SOUNDS = "assets/sounds/",
        FONTS = "assets/fonts/"
    }
}

return Constants