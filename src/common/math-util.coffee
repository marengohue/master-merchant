module.exports = class MathUtil
    @randomPoint: (xBound, yBound) ->
        {
            x: parseInt(xBound * Math.random()),
            y: parseInt(yBound * Math.random())
        }

    @manhattanDistance: (p0, p1) ->
        Math.abs(p0.x - p1.x) + Math.abs(p0.y - p1.y)