module.exports = class MathUtil
    @randomPoint: (xBound, yBound) ->
        {
            x: parseInt(xBound * Math.random())
            y: parseInt(yBound * Math.random())
        }

    @manhattanDistance: (p0, p1) ->
        Math.abs(p0.x - p1.x) + Math.abs(p0.y - p1.y)

    @equalPoints: (p0, p1) ->
        p0.x is p1.x and p0.y is p1.y

    @getNeighbours: (p) ->
        [
            { x: p.x - 1, y: p.y }
            { x: p.x, y: p.y + 1 }
            { x: p.x + 1, y: p.y }
            { x: p.x, y: p.y - 1 }
        ]