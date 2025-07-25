local Utils = {}

function Utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utils.checkCollision(a, b)
    return a.x < b.x + b.width and
           b.x < a.x + a.width and
           a.y < b.y + b.height and
           b.y < a.y + a.height
end

return Utils