module.exports = class TestUtil
    @testFailCount: (failCount, testFn) ->
        tests = failCount
        while tests isnt 0
            tests -= 1
            try
                testFn()
            catch error
                failCount -= 1
        if failCount is 0
            throw new Error 'Test failed every time'