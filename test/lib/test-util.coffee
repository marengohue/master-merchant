module.exports = class TestUtil
    @testFailCount: (failCount, testFn) ->
        lastError = null
        tests = failCount
        while tests isnt 0
            tests -= 1
            try
                testFn()
            catch error
                lastError = error
                failCount -= 1
        if failCount is 0
            throw lastError

    @testSuccessCount: (successCount, testFn) ->
        while successCount isnt 0
            testFn()
            successCount -= 1